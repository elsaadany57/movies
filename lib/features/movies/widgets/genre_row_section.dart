import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../view_models/home_view_model.dart';
import 'movie_poster_card.dart';

/// A genre heading with its "See More" link and the horizontal poster strip
/// underneath.
class GenreRowSection extends StatelessWidget {
  const GenreRowSection({super.key, required this.row, this.onSeeMore});

  final GenreRow row;
  final VoidCallback? onSeeMore;

  static const _cardWidth = 100.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.genre,
                style: TextStyle(
                  fontSize: context.sp(24),
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              GestureDetector(
                onTap: onSeeMore,
                child: Row(
                  children: [
                    Text(
                      'See More',
                      style: TextStyle(
                        fontSize: context.sp(16),
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: context.w(4)),
                    Icon(
                      Icons.arrow_forward,
                      size: context.w(16),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.h(12)),
        SizedBox(
          height: context.w(_cardWidth) / MoviePosterCard.aspectRatio,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            itemCount: row.movies.length,
            separatorBuilder: (_, _) => SizedBox(width: context.w(12)),
            itemBuilder: (_, i) => MoviePosterCard(
              movie: row.movies[i],
              width: context.w(_cardWidth),
            ),
          ),
        ),
      ],
    );
  }
}
