import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// A genre pill. Flat on the details screen; [selectable] on Browse, where
/// the chosen genre fills yellow and the rest stay outlined.
class GenreChip extends StatelessWidget {
  const GenreChip({
    super.key,
    required this.label,
    this.selected = false,
    this.selectable = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final bool selectable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final filled = selectable && selected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(10),
        ),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(16)),
          border: selectable
              ? Border.all(color: AppColors.primary, width: context.w(1.5))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.sp(16),
            fontWeight: selectable ? FontWeight.w500 : FontWeight.w400,
            color: filled ? AppColors.background : AppColors.white,
          ),
        ),
      ),
    );
  }
}
