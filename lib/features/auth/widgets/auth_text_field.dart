import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// The rounded dark field used by every auth form. Passing [obscure] turns on
/// the eye toggle, so callers never manage that state themselves.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.enabled = true,
  });

  final String hint;

  /// Asset path of the leading icon, from [AppAssets].
  final String icon;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool enabled;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.w(16));

    OutlineInputBorder border([Color? color]) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: color == null ? BorderSide.none : BorderSide(color: color),
        );

    return TextFormField(
      controller: widget.controller,
      obscureText: _hidden,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      style: TextStyle(fontSize: context.sp(16), color: AppColors.white),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: context.sp(16), color: AppColors.white),
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: _IconBox(asset: widget.icon),
        suffixIcon: widget.obscure
            ? GestureDetector(
                onTap: () => setState(() => _hidden = !_hidden),
                // The design only draws the "hidden" eye, so the visible
                // state falls back to the matching Material icon.
                child: _hidden
                    ? const _IconBox(asset: AppAssets.icEyeOff)
                    : Icon(
                        Icons.visibility,
                        color: AppColors.white,
                        size: context.w(24),
                      ),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: context.h(16)),
        border: border(),
        enabledBorder: border(),
        disabledBorder: border(),
        focusedBorder: border(AppColors.primary),
        errorBorder: border(AppColors.red),
        focusedErrorBorder: border(AppColors.red),
        errorStyle: TextStyle(color: AppColors.red, fontSize: context.sp(12)),
      ),
    );
  }
}

/// Keeps every field icon the same box size regardless of the asset's aspect.
class _IconBox extends StatelessWidget {
  const _IconBox({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(16)),
        child: Image.asset(
          asset,
          width: context.w(24),
          height: context.w(24),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
