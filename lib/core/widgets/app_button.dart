import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Full-width pill button from the design. [AppButton.filled] is the yellow
/// primary action, [AppButton.outlined] the yellow-bordered secondary one.
class AppButton extends StatelessWidget {
  const AppButton.filled({super.key, required this.label, required this.onPressed})
      : _outlined = false;

  const AppButton.outlined({super.key, required this.label, required this.onPressed})
      : _outlined = true;

  final String label;
  final VoidCallback onPressed;
  final bool _outlined;

  static const _height = 55.0;
  static final _shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  // A ButtonStyle textStyle replaces the theme's outright instead of merging
  // with it, so the family has to be named here too.
  static const _textStyle = TextStyle(
    fontFamily: AppTheme.fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    final child = Text(label);

    return SizedBox(
      width: double.infinity,
      height: _height,
      child: _outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: _shape,
                textStyle: _textStyle,
              ),
              child: child,
            )
          : FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                shape: _shape,
                textStyle: _textStyle,
              ),
              child: child,
            ),
    );
  }
}
