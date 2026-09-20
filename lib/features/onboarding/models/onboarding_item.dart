import 'package:flutter/painting.dart';

import '../../../core/constants/app_assets.dart';
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

const onboardingItems = <OnboardingItem>[
  OnboardingItem(
    image: AppAssets.onboarding2,
    title: 'Discover Movies',
    description: 'Explore a vast collection of movies in all qualities and '
        'genres. Find your next favorite film with ease.',
    fade: AppColors.tealFade,
    fadeHeightFactor: 1,
    showBack: false,
  ),
  OnboardingItem(
    image: AppAssets.onboarding3,
    title: 'Explore All Genres',
    description: 'Discover movies from every genre, in all available '
        'qualities. Find something new and exciting to watch every day.',
    fade: AppColors.redFade,
    fadeHeightFactor: 1,
  ),
  OnboardingItem(
    image: AppAssets.onboarding4,
    title: 'Create Watchlists',
    description: 'Save movies to your watchlist to keep track of what you '
        'want to watch next. Enjoy films in various qualities and genres.',
  ),
  OnboardingItem(
    image: AppAssets.onboarding5,
    title: 'Rate, Review, and Learn',
    description: "Share your thoughts on the movies you've watched. Dive deep "
        'into film details and help others discover great movies with your '
        'reviews.',
  ),
  OnboardingItem(
    image: AppAssets.onboarding6,
    title: 'Start Watching Now',
  ),
];
