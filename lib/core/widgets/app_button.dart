import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Full-width pill button from the design. [AppButton.filled] is the yellow
/// primary action, [AppButton.outlined] the yellow-bordered secondary one.
class AppButton extends StatelessWidget {
  const AppButton.filled({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color,
  }) : _outlined = false;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color,
  }) : _outlined = true;

  final String label;
  final VoidCallback onPressed;

  /// Drawn before the label, as on the "Login With Google" button.
  final Widget? icon;

  /// Swaps the label for a spinner and refuses taps while an action runs.
  final bool loading;

  /// Overrides the yellow, for the red destructive buttons.
  final Color? color;
  final bool _outlined;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.w(16)),
    );
    // A ButtonStyle textStyle replaces the theme's outright instead of merging
    // with it, so the family has to be named here too.
    final textStyle = TextStyle(
      fontFamily: AppTheme.fontFamily,
      fontSize: context.sp(20),
      fontWeight: FontWeight.w600,
    );
    final padding = EdgeInsets.symmetric(horizontal: context.w(12));

    final icon = this.icon;
    final child = loading
        ? SizedBox.square(
            dimension: context.w(24),
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          )
        : (icon == null
            ? Text(label)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  SizedBox(width: context.w(12)),
                  // Flexible so a long label ellipsises instead of overflowing
                  // the row on a narrow screen.
                  Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
                ],
              ));

    return SizedBox(
      width: double.infinity,
      height: context.h(55),
      child: _outlined
          ? OutlinedButton(
              onPressed: loading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                side: BorderSide(color: accent, width: context.w(1.5)),
                shape: shape,
                textStyle: textStyle,
                padding: padding,
              ),
              child: child,
            )
          : FilledButton(
              onPressed: loading ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: accent == AppColors.primary
                    ? AppColors.background
                    : AppColors.white,
                shape: shape,
                textStyle: textStyle,
                padding: padding,
              ),
              child: child,
            ),
    );
  }
}
