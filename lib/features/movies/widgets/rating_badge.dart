import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// The "7.7 ★" chip that sits on the top-left corner of every poster.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(4)),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.w(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: context.w(4)),
          Icon(Icons.star, size: context.w(14), color: AppColors.primary),
        ],
      ),
    );
  }
}
