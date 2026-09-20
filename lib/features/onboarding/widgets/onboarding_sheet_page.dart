import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../models/onboarding_item.dart';
import 'poster_background.dart';

/// Onboarding page with a poster on top and a rounded bottom sheet holding
/// the title, description and Next/Finish + Back buttons.
class OnboardingSheetPage extends StatelessWidget {
  const OnboardingSheetPage({
    super.key,
    required this.item,
    required this.isLast,
    required this.onNext,
    required this.onBack,
  });

  final OnboardingItem item;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final description = item.description;

    return Stack(
      children: [
        PosterBackground(
          image: item.image,
          fade: item.fade,
          fadeHeightFactor: item.fadeHeightFactor,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 32, 16, bottomInset + 16),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      color: AppColors.white,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AppButton.filled(
                  label: isLast ? 'Finish' : 'Next',
                  onPressed: onNext,
                ),
                if (item.showBack) ...[
                  const SizedBox(height: 16),
                  AppButton.outlined(label: 'Back', onPressed: onBack),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
