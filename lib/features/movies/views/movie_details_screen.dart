import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../../core/widgets/network_poster.dart';
import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';
import '../view_models/movie_details_view_model.dart';
import '../widgets/movie_poster_card.dart';
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
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            _Backdrop(movie: movie),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${movie.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _WatchButton(),
                  const SizedBox(height: 16),
                  _StatsRow(movie: movie),
                ],
              ),
            ),
            if (movie.screenshots.isNotEmpty) ...[
              const SizedBox(height: 24),
              const _SectionTitle('Screen Shots'),
              const SizedBox(height: 12),
              for (final shot in movie.screenshots) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: NetworkPoster(url: shot, radius: 12),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
            if (suggestions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const _SectionTitle('More Like This'),
              const SizedBox(height: 12),
              SizedBox(
                height: 100 / MoviePosterCard.aspectRatio,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: suggestions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, i) =>
                      MoviePosterCard(movie: suggestions[i], width: 100),
                ),
              ),
            ],
            if (movie.summary.isNotEmpty) ...[
              const SizedBox(height: 24),
              const _SectionTitle('Summary'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  movie.summary,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
        const _TopBar(),
      ],
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

/// The yellow ring with a white play triangle over the backdrop.
class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 97,
      height: 97,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: AppColors.white, width: 6),
      ),
      child: const Icon(Icons.play_arrow, size: 48, color: AppColors.white),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.white, size: 28),
            ),
            IconButton(
              // TODO: persist the watchlist once the profile tab exists.
              onPressed: () {},
              icon: const Icon(Icons.bookmark,
                  color: AppColors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchButton extends StatelessWidget {
  const _WatchButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton(
        // TODO: open the trailer once a player is picked.
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        child: const Text('Watch'),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MovieStatChip(
            icon: Icons.favorite,
            label: '${movie.likeCount ?? 0}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MovieStatChip(
            icon: Icons.access_time_filled,
            label: '${movie.runtime}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MovieStatChip(
            icon: Icons.star,
            label: movie.rating.toStringAsFixed(1),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
