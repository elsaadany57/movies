import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

/// Pill switch between the two locales. Selection is local for now; it will
/// drive the app's locale once localisation lands.
class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  bool _arabic = false;

  static const _flagSize = 32.0;
  static const _padding = 4.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _arabic = !_arabic),
      child: Container(
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Flag(asset: AppAssets.flagUs, selected: !_arabic),
            const SizedBox(width: _padding * 2),
            _Flag(asset: AppAssets.flagEg, selected: _arabic),
          ],
        ),
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag({required this.asset, required this.selected});

  final String asset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : Colors.transparent,
      ),
      child: Opacity(
        opacity: selected ? 1 : 0.5,
        child: Image.asset(
          asset,
          width: _LanguageToggleState._flagSize,
          height: _LanguageToggleState._flagSize,
        ),
      ),
    );
  }
}
