import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/localization/locale_view_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// Pill switch between English and Arabic. Choosing one changes the app's
/// language straight away and is remembered for next launch.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final arabic = context.select<LocaleViewModel, bool>((l) => l.isArabic);
    final gap = context.w(8);

    // Always laid out left to right: English on the left, Arabic on the
    // right. Otherwise the two flags would swap places every time the
    // language changed, because Arabic mirrors every row on the screen.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: context.read<LocaleViewModel>().toggle,
        child: Container(
          padding: EdgeInsets.all(context.w(4)),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(context.w(30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Flag(asset: AppAssets.flagUs, selected: !arabic),
              SizedBox(width: gap),
              _Flag(asset: AppAssets.flagEg, selected: arabic),
            ],
          ),
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
          width: context.w(32),
          height: context.w(32),
        ),
      ),
    );
  }
}
