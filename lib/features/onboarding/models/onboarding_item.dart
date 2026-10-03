import 'package:flutter/painting.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_colors.dart';

/// Content + layout flags for one onboarding page.
class OnboardingItem {
  const OnboardingItem({
    required this.image,
    required this.title,
    this.description,
    this.fade = AppColors.backgroundFade,
    this.fadeHeightFactor = 0.5,
    this.showBack = true,
  });

  final String image;
  final String title;
  final String? description;

  /// Gradient laid over the bottom of the poster so it melts into the sheet.
  final Gradient fade;

  /// How much of the poster (from the bottom) the [fade] spans.
  final double fadeHeightFactor;

  /// Whether the sheet shows a Back button.
  final bool showBack;
}

/// The poster behind each sheet page, in order. Kept apart from the words so
/// they can be preloaded without a BuildContext, and so the page count does
/// not depend on the language.
const onboardingImages = [
  AppAssets.onboarding2,
  AppAssets.onboarding3,
  AppAssets.onboarding4,
  AppAssets.onboarding5,
  AppAssets.onboarding6,
];

/// The sheet pages after the intro, worded in the current language.
List<OnboardingItem> onboardingItems(AppLocalizations l10n) => [
      OnboardingItem(
        image: onboardingImages[0],
        title: l10n.onboardingDiscoverTitle,
        description: l10n.onboardingDiscoverDescription,
        fade: AppColors.tealFade,
        fadeHeightFactor: 1,
        showBack: false,
      ),
      OnboardingItem(
        image: onboardingImages[1],
        title: l10n.onboardingGenresTitle,
        description: l10n.onboardingGenresDescription,
        fade: AppColors.redFade,
        fadeHeightFactor: 1,
      ),
      OnboardingItem(
        image: onboardingImages[2],
        title: l10n.onboardingWatchlistTitle,
        description: l10n.onboardingWatchlistDescription,
      ),
      OnboardingItem(
        image: onboardingImages[3],
        title: l10n.onboardingReviewTitle,
        description: l10n.onboardingReviewDescription,
      ),
      OnboardingItem(
        image: onboardingImages[4],
        title: l10n.onboardingStartTitle,
      ),
    ];
