import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The Google mark as the design draws it: one solid colour, not the
/// four-colour logo, so it reads against the yellow button.
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 26, this.color = AppColors.background});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _GooglePainter(color)),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final centre = Offset(s / 2, s / 2);
    final stroke = s * 0.26;
    final radius = (s - stroke) / 2;
    final paint = Paint()..color = color;

    // The ring, open where the crossbar leaves it.
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -0.30,
      5.55,
      false,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    // The crossbar, running from the centre out to the right edge.
    canvas.drawRect(
      Rect.fromLTRB(centre.dx - stroke * 0.1, centre.dy - stroke / 2, s, centre.dy + stroke / 2),
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _GooglePainter old) => old.color != color;
}
