import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../view_models/home_view_model.dart';
import 'movie_poster_card.dart';

/// A genre heading with its "See More" link and the horizontal poster strip
/// underneath.
class GenreRowSection extends StatelessWidget {
  const GenreRowSection({super.key, required this.row, this.onSeeMore});

  final GenreRow row;
  final VoidCallback? onSeeMore;

  static const _cardWidth = 100.0;
  static const _gap = 12.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.genre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              GestureDetector(
                onTap: onSeeMore,
                child: const Row(
                  children: [
                    Text(
                      'See More',
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: _cardWidth / MoviePosterCard.aspectRatio,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: row.movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: _gap),
            itemBuilder: (_, i) => MoviePosterCard(
              movie: row.movies[i],
              width: _cardWidth,
            ),
          ),
        ),
      ],
    );
  }
}
