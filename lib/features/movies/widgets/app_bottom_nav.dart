import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

/// The floating rounded tab bar. The selected tab turns yellow; the rest
/// stay white.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const items = [
    AppAssets.navHome,
    AppAssets.navSearch,
    AppAssets.navBrowse,
    AppAssets.navProfile,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: Center(
                  child: Image.asset(
                    items[i],
                    width: 26,
                    height: 26,
                    fit: BoxFit.contain,
                    color: i == currentIndex
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
