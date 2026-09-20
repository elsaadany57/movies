import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// The panel of every avatar, shown under the update-profile form. The
/// chosen one fills yellow; the rest are outlined.
class AvatarGridSheet extends StatelessWidget {
  const AvatarGridSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(20)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: context.w(12),
          mainAxisSpacing: context.h(12),
        ),
        itemCount: AppAssets.avatars.length,
        itemBuilder: (context, i) {
          final isSelected = i == selected;

          return GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              padding: EdgeInsets.all(context.w(6)),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: AppColors.primary,
                  width: context.w(1.5),
                ),
                borderRadius: BorderRadius.circular(context.w(16)),
              ),
              child: Image.asset(AppAssets.avatars[i]),
            ),
          );
        },
      ),
    );
  }
}
