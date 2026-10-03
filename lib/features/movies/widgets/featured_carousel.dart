import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/network_poster.dart';
import '../../../data/models/movie.dart';
import 'brush_heading.dart';
import 'movie_poster_card.dart';
import '../../../core/localization/l10n.dart';

/// The top of the home screen: the selected movie's artwork blurred behind
/// "Available Now", a swipeable poster carousel, and the "Watch Now" script.
///
/// The carousel loops, so the centred poster always has a neighbour on each
/// side, as in the design, including on the very first one.
class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key, required this.movies});

  final List<Movie> movies;

  /// Below this a loop would show the same poster twice in one view.
  static const minMoviesToLoop = 3;

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  static const _cardWidth = 238.0;

  /// Distance between the centres of two neighbouring posters, measured off
  /// the design. A touch narrower than the card, so the centred poster sits
  /// just inside its slot and the neighbours are cut by the screen edge.
  static const _pageSpacing = 232.0;
  static const _viewport = _pageSpacing / Responsive.designWidth;

  /// Measured off the design: the neighbours stand about 78% as tall as
  /// whichever poster is centred.
  static const _minScale = 0.78;

  /// Enough to soften the artwork without turning it to mush.
  static const _blur = 8.0;

  /// How far into the infinite page range to start, so there is room to
  /// swipe backwards from the first poster. A multiple of the length keeps
  /// the first poster centred.
  static const _loopOffset = 1000;

  bool get _loops => widget.movies.length >= FeaturedCarousel.minMoviesToLoop;

  late final _controller = PageController(
    viewportFraction: _viewport,
    initialPage: _loops ? widget.movies.length * _loopOffset : 0,
  );

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
            BrushHeading(
              image: AppAssets.availableNow,
              text: context.l10n.availableNow,
              imageWidth: 265,
              arabicFontSize: 52,
            ),
            SizedBox(height: context.h(16)),
            SizedBox(
              height: cardHeight,
              child: PageView.builder(
                controller: _controller,
                // Null means endless, which is what makes it loop.
                itemCount: _loops ? null : movies.length,
                onPageChanged: (page) =>
                    setState(() => _selected = page % movies.length),
                itemBuilder: (_, page) => _Scaled(
                  controller: _controller,
                  page: page,
                  child: MoviePosterCard(
                    movie: movies[page % movies.length],
                    width: cardWidth,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(24)),
            BrushHeading(
              image: AppAssets.watchNow,
              text: context.l10n.watchNow,
              imageWidth: 351,
              arabicFontSize: 76,
            ),
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
    required this.page,
    required this.child,
  });

  final PageController controller;

  /// This widget's raw page number, not the movie index: with looping the
  /// two differ.
  final int page;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Until the first layout the controller has no position, so the
        // page it was told to start on is the best answer.
        final current = controller.hasClients && controller.position.haveDimensions
            ? (controller.page ?? controller.initialPage.toDouble())
            : controller.initialPage.toDouble();

        final distance = (current - page).abs().clamp(0.0, 1.0);
        final scale = 1 - (1 - _FeaturedCarouselState._minScale) * distance;

        return Center(child: Transform.scale(scale: scale, child: child));
      },
      child: child,
    );
  }
}
