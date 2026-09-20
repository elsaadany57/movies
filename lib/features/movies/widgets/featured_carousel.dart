import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/network_poster.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/movie.dart';
import 'movie_poster_card.dart';

/// The top of the home screen: the selected movie's artwork blurred behind
/// "Available Now", a swipeable poster carousel, and the "Watch Now" script.
class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key, required this.movies});

  final List<Movie> movies;

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  /// Narrower than the card so neighbours tuck in behind the centred one,
  /// the way the design overlaps them.
  static const _viewport = 0.52;
  static const _cardWidth = 238.0;

  /// Measured off the design: the neighbours stand about 78% as tall as
  /// whichever poster is centred.
  static const _minScale = 0.78;

  /// Enough to soften the artwork without turning it to mush.
  static const _blur = 8.0;

  late final _controller = PageController(viewportFraction: _viewport);

  int _selected = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.movies;
    if (movies.isEmpty) return const SizedBox.shrink();

    final backdrop = movies[_selected.clamp(0, movies.length - 1)];
    final cardWidth = context.w(_cardWidth);
    final cardHeight = cardWidth / MoviePosterCard.aspectRatio;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // The centred movie's own artwork, lightly blurred, dimmed by the
        // gradient so it settles into the page background at the bottom.
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: _blur,
              sigmaY: _blur,
              tileMode: TileMode.decal,
            ),
            // The poster art, not the wide `background_image`: the design
            // blows up the same artwork as the centred card, and a cover
            // image is always present where a backdrop sometimes is not.
            child: NetworkPoster(
              key: ValueKey(backdrop.id),
              url: backdrop.coverUrl,
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.featuredFade),
          ),
        ),
        Column(
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top + context.h(8)),
            Image.asset(AppAssets.availableNow, width: context.w(265)),
            SizedBox(height: context.h(16)),
            SizedBox(
              height: cardHeight,
              child: PageView.builder(
                controller: _controller,
                itemCount: movies.length,
                onPageChanged: (i) => setState(() => _selected = i),
                itemBuilder: (_, i) => _Scaled(
                  controller: _controller,
                  index: i,
                  fallbackSelected: _selected,
                  child: MoviePosterCard(movie: movies[i], width: cardWidth),
                ),
              ),
            ),
            SizedBox(height: context.h(24)),
            Image.asset(AppAssets.watchNow, width: context.w(351)),
            SizedBox(height: context.h(24)),
          ],
        ),
      ],
    );
  }
}

/// Shrinks a page as it moves away from centre, so the focused poster stands
/// taller than its neighbours. Tracks the controller rather than the settled
/// page, so the size follows the finger mid-swipe.
class _Scaled extends StatelessWidget {
  const _Scaled({
    required this.controller,
    required this.index,
    required this.fallbackSelected,
    required this.child,
  });

  final PageController controller;
  final int index;

  /// Used until the controller has been laid out and knows its page.
  final int fallbackSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final hasPage =
            controller.hasClients && controller.position.haveDimensions;
        final page = hasPage
            ? (controller.page ?? fallbackSelected.toDouble())
            : fallbackSelected.toDouble();

        final distance = (page - index).abs().clamp(0.0, 1.0);
        final scale = 1 - (1 - _FeaturedCarouselState._minScale) * distance;

        return Center(child: Transform.scale(scale: scale, child: child));
      },
      child: child,
    );
  }
}
