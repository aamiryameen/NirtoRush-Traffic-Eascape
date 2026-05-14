import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Gradient background + animated parallax stars/lights so even procedural
/// art has motion appeal.
class SkyRenderer extends PositionComponent {
  SkyRenderer({required this.topColor, required this.bottomColor})
      : super(priority: -1);

  Color topColor;
  Color bottomColor;
  double scroll = 0;

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [topColor, bottomColor],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }
}
