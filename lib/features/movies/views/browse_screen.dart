import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_state_view.dart';
import '../view_models/browse_view_model.dart';
import '../widgets/genre_chip.dart';
import '../widgets/movie_grid.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<BrowseViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BrowseViewModel>();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          SizedBox(
            height: context.h(56),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              itemCount: BrowseViewModel.genres.length,
              separatorBuilder: (_, _) => SizedBox(width: context.w(12)),
              itemBuilder: (_, i) {
                final genre = BrowseViewModel.genres[i];
                return Center(
                  child: GenreChip(
                    label: genre,
                    selectable: true,
                    selected: genre == vm.genre,
                    onTap: () =>
                        context.read<BrowseViewModel>().selectGenre(genre),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: context.h(16)),
          Expanded(
            child: switch (vm) {
              _ when vm.isLoading || vm.error != null => AppStateView(
                  isLoading: vm.isLoading,
                  error: vm.error,
                  onRetry: context.read<BrowseViewModel>().load,
                ),
              _ when vm.movies.isEmpty =>
                AppStateView(emptyMessage: 'No ${vm.genre} movies found'),
              _ => MovieGrid(movies: vm.movies),
            },
          ),
        ],
      ),
    );
  }
}
