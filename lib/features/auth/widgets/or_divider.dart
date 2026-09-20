import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Yellow rule either side of the word OR.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const line = Expanded(child: Divider(color: AppColors.primary, height: 1));

    return const Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(fontSize: 16, color: AppColors.primary),
          ),
        ),
        line,
      ],
    );
  }
}
