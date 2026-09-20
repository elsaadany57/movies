import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Full-width pill button from the design. [AppButton.filled] is the yellow
/// primary action, [AppButton.outlined] the yellow-bordered secondary one.
class AppButton extends StatelessWidget {
  const AppButton.filled({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _outlined = false;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _outlined = true;

  final String label;
  final VoidCallback onPressed;

  /// Drawn before the label, as on the "Login With Google" button.
  final Widget? icon;
  final bool _outlined;

  static const _height = 55.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 12);
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
    final icon = this.icon;
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 12),
              // Flexible so a long label ellipsises instead of overflowing
              // the row on a narrow screen.
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

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
                padding: _padding,
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
                padding: _padding,
              ),
              child: child,
            ),
    );
  }
}
