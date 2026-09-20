import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../../core/widgets/network_poster.dart';
import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';
import '../view_models/movie_details_view_model.dart';
import '../widgets/cast_tile.dart';
import '../widgets/genre_chip.dart';
import '../widgets/movie_grid.dart';
import '../widgets/movie_stat_chip.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    // Each visit gets its own view model, so two movies never share state.
    return ChangeNotifierProvider(
      create: (_) =>
          MovieDetailsViewModel(context.read<MovieRepository>())..load(movieId),
      child: const _MovieDetailsBody(),
    );
  }
}

class _MovieDetailsBody extends StatelessWidget {
  const _MovieDetailsBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovieDetailsViewModel>();
    final movie = vm.movie;

    return Scaffold(
      body: movie == null
          ? SafeArea(
              child: AppStateView(isLoading: vm.isLoading, error: vm.error),
            )
          : _Content(movie: movie, suggestions: vm.suggestions),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.movie, required this.suggestions});

  final Movie movie;
  final List<Movie> suggestions;

  @override
  Widget build(BuildContext context) {
    final sidePadding = EdgeInsets.symmetric(horizontal: context.w(16));

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            _Backdrop(movie: movie),
            SizedBox(height: context.h(24)),
            Padding(
              padding: sidePadding,
              child: Column(
                children: [
                  Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.sp(24),
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: context.h(8)),
                  Text(
                    '${movie.year}',
                    style: TextStyle(
                      fontSize: context.sp(16),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: context.h(16)),
                  AppButton.filled(
                    label: 'Watch',
                    color: AppColors.red,
                    // TODO: open the trailer once a player is picked.
                    onPressed: () {},
                  ),
                  SizedBox(height: context.h(16)),
                  _StatsRow(movie: movie),
                ],
              ),
            ),
            if (movie.screenshots.isNotEmpty) ...[
              _Heading('Screen Shots'),
              for (final shot in movie.screenshots)
                Padding(
                  padding: sidePadding.copyWith(bottom: context.h(12)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: NetworkPoster(url: shot, radius: context.w(12)),
                  ),
                ),
            ],
            if (suggestions.isNotEmpty) ...[
              _Heading('Similar'),
              MovieGrid(
                movies: suggestions,
                shrinkWrap: true,
                padding: sidePadding,
              ),
            ],
            if (movie.summary.isNotEmpty) ...[
              _Heading('Summary'),
              Padding(
                padding: sidePadding,
                child: Text(
                  movie.summary,
                  style: TextStyle(
                    fontSize: context.sp(16),
                    height: 1.5,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
            if (movie.cast.isNotEmpty) ...[
              _Heading('Cast'),
              for (final member in movie.cast)
                Padding(
                  padding: sidePadding.copyWith(bottom: context.h(12)),
                  child: CastTile(member: member),
                ),
            ],
            if (movie.genres.isNotEmpty) ...[
              _Heading('Genres'),
              Padding(
                padding: sidePadding,
                child: Wrap(
                  spacing: context.w(12),
                  runSpacing: context.h(12),
                  children: [
                    for (final genre in movie.genres) GenreChip(label: genre),
                  ],
                ),
              ),
            ],
            SizedBox(height: context.h(32)),
          ],
        ),
        const _TopBar(),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(16),
        context.h(24),
        context.w(16),
        context.h(12),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 430 / 520,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkPoster(url: movie.backgroundUrl),
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.backgroundFade),
          ),
          if (movie.hasTrailer) const Center(child: _PlayButton()),
        ],
      ),
    );
  }
}

/// The yellow disc with a white ring and play triangle over the backdrop.
class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(97),
      height: context.w(97),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: AppColors.white, width: context.w(6)),
      ),
      child: Icon(
        Icons.play_arrow,
        size: context.w(48),
        color: AppColors.white,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.white,
                size: context.w(28),
              ),
            ),
            IconButton(
              // TODO: persist the watchlist once the profile tab stores it.
              onPressed: () {},
              icon: Icon(
                Icons.bookmark,
                color: AppColors.white,
                size: context.w(28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (Icons.favorite, '${movie.likeCount ?? 0}'),
      (Icons.access_time_filled, '${movie.runtime}'),
      (Icons.star, movie.rating.toStringAsFixed(1)),
    ];

    return Row(
      children: [
        for (final (index, (icon, label)) in stats.indexed) ...[
          if (index > 0) SizedBox(width: context.w(12)),
          Expanded(child: MovieStatChip(icon: icon, label: label)),
        ],
      ],
    );
  }
}
