import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import 'poster_background.dart';

/// First onboarding page: poster collage, headline and "Explore Now".
class OnboardingIntroPage extends StatelessWidget {
  const OnboardingIntroPage({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        const PosterBackground(
          image: AppAssets.onboarding1,
          fade: AppColors.introFade,
          fadeHeightFactor: 0.6,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, math.max(bottomInset, 34)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Find Your Next\nFavorite Movie Here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Get access to a huge library of movies\n'
                  'to suit all tastes. You will surely like it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                AppButton.filled(label: 'Explore Now', onPressed: onExplore),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
