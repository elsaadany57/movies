import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/errors/load_error.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../auth/views/login_screen.dart';
import '../../../data/models/movie.dart';
import '../../movies/widgets/movie_grid.dart';
import '../view_models/library_view_model.dart';
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
    final library = context.watch<LibraryViewModel>();
    final user = vm.user;

    if (user == null) {
      return SafeArea(
        child: AppStateView(
          isLoading: vm.isLoading,
          error: vm.error,
          emptyMessage: vm.isLoading ? null : context.l10n.notSignedIn,
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
                        value: library.watchList.length,
                        label: context.l10n.wishList,
                      ),
                    ),
                    Expanded(
                      child: _Count(
                        value: library.history.length,
                        label: context.l10n.history,
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
                        label: context.l10n.editProfile,
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
                        label: context.l10n.exit,
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
              _tab(context, AppAssets.icWatchlist, context.l10n.watchList),
              _tab(context, AppAssets.icHistory, context.l10n.history),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _MovieList(movies: library.watchList),
                _MovieList(movies: library.history),
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

/// One tab's grid of posters, or the shared state view while it loads, fails
/// or has nothing to show yet.
class _MovieList extends StatelessWidget {
  const _MovieList({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isNotEmpty) return MovieGrid(movies: movies, columns: 3);

    final library = context.watch<LibraryViewModel>();
    return AppStateView(
      isLoading: library.isLoading,
      error: library.hasError ? LoadError.library : null,
      onRetry: context.read<LibraryViewModel>().load,
    );
  }
}
