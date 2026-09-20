import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
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
  static const _viewport = 0.62;
  static const _cardWidth = 238.0;

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
        // Blurred artwork of whichever poster is centred.
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.transparent],
            ).createShader(rect),
            blendMode: BlendMode.dstIn,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Opacity(
                opacity: 0.5,
                child: NetworkPoster(url: backdrop.backgroundUrl),
              ),
            ),
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
                itemBuilder: (_, i) => Center(
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
