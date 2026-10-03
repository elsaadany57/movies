import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// One of the home screen's two big brush-script headings.
///
/// In English it is the design's own artwork. An image cannot be translated,
/// so in Arabic the same words are set in a calligraphic font at a matching
/// size instead, which keeps the page from showing English in the middle of
/// an Arabic screen.
class BrushHeading extends StatelessWidget {
  const BrushHeading({
    super.key,
    required this.image,
    required this.text,
    required this.imageWidth,
    required this.arabicFontSize,
  });

  /// The design's artwork, used for every language except Arabic.
  final String image;

  /// The translated words, drawn as text in Arabic.
  final String text;

  /// How wide the artwork is on the 430-wide design.
  final double imageWidth;

  /// Font size of the Arabic text on the 430-wide design.
  final double arabicFontSize;

  @override
  Widget build(BuildContext context) {
    if (Localizations.localeOf(context).languageCode != 'ar') {
      return Image.asset(image, width: context.w(imageWidth));
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'ArefRuqaa',
        fontWeight: FontWeight.w700,
        fontSize: context.sp(arabicFontSize),
        height: 1.1,
        color: AppColors.white,
      ),
    );
  }
}
