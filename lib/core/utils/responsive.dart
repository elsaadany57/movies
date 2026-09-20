import 'package:flutter/widgets.dart';

/// Scales the numbers measured on the design to whatever screen the app is
/// actually running on.
///
/// The designs are a fixed 430x932 frame, so a literal `55` is only right on
/// that one device. Pass the design number and let the device decide:
///
/// ```dart
/// SizedBox(height: context.h(24));
/// Text('Login', style: TextStyle(fontSize: context.sp(20)));
/// ```
extension Responsive on BuildContext {
  /// The frame every screenshot in `design/` was exported at.
  static const designWidth = 430.0;
  static const designHeight = 932.0;

  /// Keeps text and touch targets sane on tablets and desktop windows, where
  /// scaling purely by width would balloon everything.
  static const _maxScale = 1.35;

  double get _widthScale =>
      (MediaQuery.sizeOf(this).width / designWidth).clamp(0.0, _maxScale);

  double get _heightScale =>
      (MediaQuery.sizeOf(this).height / designHeight).clamp(0.0, _maxScale);

  /// Horizontal sizes: widths, paddings, radii, icon sizes.
  double w(double design) => design * _widthScale;

  /// Vertical sizes: heights and the gaps between stacked widgets.
  double h(double design) => design * _heightScale;

  /// Font sizes. Tracks width so text stays in proportion to the layout it
  /// sits in; the platform's own text scaling still applies on top.
  double sp(double design) => design * _widthScale;
}
