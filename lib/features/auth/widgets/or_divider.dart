import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// Yellow rule either side of the word OR.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(color: AppColors.primary, height: context.h(1)),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(12)),
          child: Text(
            'OR',
            style: TextStyle(fontSize: context.sp(16), color: AppColors.primary),
          ),
        ),
        line,
      ],
    );
  }
}
