import 'package:flutter/material.dart';

/// Color styles from the design file.
class AppColors {
  static const background = Color(0xFF121312);
  static const surface = Color(0xFF282A28);
  static const primary = Color(0xFFFFBB3B);
  static const white = Color(0xFFFFFFFF);
  static const green = Color(0xFF57AA53);
  static const red = Color(0xFFE82626);

  /// Muted text used for descriptions on the intro page.
  static const textSecondary = Color(0xB3FFFFFF);

  /// Bottom-fade overlays used on the onboarding posters.
  static const tealFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00084250), Color(0xFF084250)],
  );

  static const redFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x0085210E), Color(0xFF85210E)],
  );

  static const backgroundFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00121312), background],
  );

  /// Stronger fade for the intro collage so the headline stays readable.
  static const introFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00121312), Color(0xE6121312), background],
    stops: [0, 0.55, 1],
  );
}
