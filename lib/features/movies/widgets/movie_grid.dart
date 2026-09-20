import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';
import '../../../data/models/movie.dart';
import 'movie_poster_card.dart';

/// The two-column poster grid shared by Search, Browse, the profile tabs and
/// the "Similar" section of the details screen.
class MovieGrid extends StatelessWidget {
  const MovieGrid({
    super.key,
    required this.movies,
    this.columns = 2,
    this.padding,
    this.shrinkWrap = false,
  });

  final List<Movie> movies;
  final int columns;
  final EdgeInsets? padding;

  /// True when the grid sits inside another scrollable, as on the details
  /// screen; false when it is the scrollable.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ??
          // The bottom inset clears the floating tab bar.
          EdgeInsets.fromLTRB(
            context.w(16),
            0,
            context.w(16),
            context.h(90),
          ),
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: context.w(12),
        mainAxisSpacing: context.h(12),
        childAspectRatio: MoviePosterCard.aspectRatio,
      ),
      itemCount: movies.length,
      itemBuilder: (context, i) => LayoutBuilder(
        builder: (_, constraints) => MoviePosterCard(
          movie: movies[i],
          width: constraints.maxWidth,
        ),
      ),
    );
  }
}
