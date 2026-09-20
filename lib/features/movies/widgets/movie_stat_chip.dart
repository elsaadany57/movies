import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// One of the three rounded stats under the Watch button: likes, runtime
/// and rating.
class MovieStatChip extends StatelessWidget {
  const MovieStatChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(47),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: context.w(22), color: AppColors.primary),
          SizedBox(width: context.w(8)),
          Text(
            label,
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
