import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/responsive.dart';
import 'poster_background.dart';
import '../../../core/localization/l10n.dart';

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
            padding: EdgeInsets.fromLTRB(
              context.w(16), 0, context.w(16), math.max(bottomInset, context.h(34))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.introHeadline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.sp(36),
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.h(16)),
                Text(
                  context.l10n.introDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.sp(20),
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.h(24)),
                AppButton.filled(
                  label: context.l10n.exploreNow,
                  onPressed: onExplore,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
