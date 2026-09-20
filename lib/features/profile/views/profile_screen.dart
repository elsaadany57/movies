import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../auth/views/login_screen.dart';
import '../../movies/widgets/movie_grid.dart';
import '../view_models/profile_view_model.dart';
import 'update_profile_screen.dart';

/// The profile tab: who you are, your counts, and the Watch List / History
/// tabs underneath.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileViewModel>().load();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _exit() async {
    await context.read<ProfileViewModel>().signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final user = vm.user;

    if (user == null) {
      return SafeArea(
        child: AppStateView(
          isLoading: vm.isLoading,
          error: vm.error,
          emptyMessage: vm.isLoading ? null : 'You are not signed in',
          onRetry: context.read<ProfileViewModel>().load,
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          AppAssets.avatarAt(user.avatar),
                          width: context.w(118),
                        ),
                        SizedBox(height: context.h(8)),
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: _Count(
                        value: vm.watchList.length,
                        label: 'Wish List',
                      ),
                    ),
                    Expanded(
                      child: _Count(
                        value: vm.history.length,
                        label: 'History',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(16)),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppButton.filled(
                        label: 'Edit Profile',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const UpdateProfileScreen(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(12)),
                    Expanded(
                      flex: 2,
                      child: AppButton.filled(
                        label: 'Exit',
                        color: AppColors.red,
                        icon: Icon(
                          Icons.logout,
                          size: context.w(20),
                          color: AppColors.white,
                        ),
                        onPressed: _exit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabs,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white,
            labelStyle: TextStyle(fontSize: context.sp(16)),
            tabs: [
              _tab(context, AppAssets.icWatchlist, 'Watch List'),
              _tab(context, AppAssets.icHistory, 'History'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _List(ids: vm.watchList),
                _List(ids: vm.history),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, String icon, String label) {
    return Tab(
      icon: Image.asset(
        icon,
        height: context.w(20),
        color: AppColors.primary,
      ),
      text: label,
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: context.sp(24),
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: context.h(8)),
        Text(
          label,
          style: TextStyle(
            fontSize: context.sp(16),
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.ids});

  final List<int> ids;

  @override
  Widget build(BuildContext context) {
    // Nothing is stored yet, so this is always the empty state for now.
    if (ids.isEmpty) return const AppStateView();
    return MovieGrid(movies: const [], columns: 3);
  }
}
