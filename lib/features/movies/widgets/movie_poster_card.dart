import 'package:flutter/material.dart';

import '../../../core/widgets/network_poster.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/movie.dart';
import '../views/movie_details_screen.dart';
import 'rating_badge.dart';

/// A poster with its rating badge, used by the featured carousel and by
/// every genre row. Tapping it opens the details screen.
class MoviePosterCard extends StatelessWidget {
  const MoviePosterCard({
    super.key,
    required this.movie,
    required this.width,
    this.radius,
  });

  final Movie movie;
  final double width;
  final double? radius;

  /// Posters are 2:3, which is what the API's cover images use.
  static const aspectRatio = 2 / 3;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MovieDetailsScreen(movieId: movie.id),
        ),
      ),
      child: SizedBox(
        width: width,
        height: width / aspectRatio,
        child: Stack(
          children: [
            Positioned.fill(
              child: NetworkPoster(
                url: movie.coverUrl,
                radius: radius ?? context.w(12),
              ),
            ),
            PositionedDirectional(
              top: context.h(8),
              start: context.w(8),
              child: RatingBadge(rating: movie.rating),
            ),
          ],
        ),
      ),
    );
  }
}
