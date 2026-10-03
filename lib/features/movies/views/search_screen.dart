import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_state_view.dart';
import '../view_models/search_view_model.dart';
import '../widgets/movie_grid.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: TextField(
              onChanged: context.read<SearchViewModel>().onTermChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: context.sp(16), color: AppColors.white),
              decoration: InputDecoration(
                hintText: context.l10n.search,
                hintStyle: TextStyle(
                  fontSize: context.sp(16),
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.surface,
                prefixIcon: Icon(Icons.search,
                    color: AppColors.white, size: context.w(24)),
                contentPadding: EdgeInsets.symmetric(vertical: context.h(18)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.w(16)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _Results(vm: vm)),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.vm});

  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.isEmptyTerm) {
      return AppStateView(emptyMessage: context.l10n.searchPrompt);
    }
    if (vm.isLoading || vm.error != null) {
      return AppStateView(
        isLoading: vm.isLoading,
        error: vm.error,
        onRetry: context.read<SearchViewModel>().search,
      );
    }
    if (vm.results.isEmpty) {
      return AppStateView(emptyMessage: context.l10n.noMoviesMatch(vm.term));
    }
    return MovieGrid(movies: vm.results);
  }
}
