import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Poster artwork pinned to the top of the screen at full width, with a
/// gradient over its lower part so it melts into whatever sits below.
class PosterBackground extends StatelessWidget {
  const PosterBackground({
    super.key,
    required this.image,
    this.fade = AppColors.backgroundFade,
    this.fadeHeightFactor = 0.5,
  });

  final String image;
  final Gradient fade;

  /// How much of the poster's height (from the bottom) the gradient covers.
  final double fadeHeightFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Image.asset(
            image,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: fadeHeightFactor,
                widthFactor: 1,
                child: DecoratedBox(decoration: BoxDecoration(gradient: fade)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
