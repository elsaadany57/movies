import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

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
  });

  final String hint;

  /// Asset path of the leading icon, from [AppAssets].
  final String icon;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _hidden = widget.obscure;

  static const _radius = BorderRadius.all(Radius.circular(16));

  static OutlineInputBorder _border([Color? color]) => OutlineInputBorder(
        borderRadius: _radius,
        borderSide:
            color == null ? BorderSide.none : BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _hidden,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      style: const TextStyle(fontSize: 16, color: AppColors.white),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(fontSize: 16, color: AppColors.white),
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
                    : const Icon(Icons.visibility, color: AppColors.white),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.red),
        focusedErrorBorder: _border(AppColors.red),
        errorStyle: const TextStyle(color: AppColors.red),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Image.asset(asset, width: 24, height: 24, fit: BoxFit.contain),
      ),
    );
  }
}
