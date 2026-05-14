import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Vertical motion-blur streaks rendered behind the player when nitro
/// is engaged. Intensity scales with [opacity].
class SpeedLines extends PositionComponent {
  SpeedLines({required this.bounds}) : super(priority: 50);

  Vector2 bounds;
  double opacity = 0;

  final _r = Random();
  late final List<_Line> _lines = List.generate(28, (_) => _Line.random(_r, bounds));

  @override
  void update(double dt) {
    super.update(dt);
    for (final l in _lines) {
      l.y += l.speed * dt;
      if (l.y > bounds.y) l.reset(_r, bounds);
    }
  }

  @override
  void render(Canvas canvas) {
    if (opacity <= 0.02) return;
    for (final l in _lines) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * l.alpha)
        ..strokeWidth = l.thickness;
      canvas.drawLine(
        Offset(l.x, l.y),
        Offset(l.x, l.y + l.length),
        paint,
      );
    }
  }
}

class _Line {
  double x = 0, y = 0, length = 40, speed = 800, thickness = 2, alpha = 0.6;
  _Line.random(Random r, Vector2 b) {
    reset(r, b);
  }
  void reset(Random r, Vector2 b) {
    x = r.nextDouble() * b.x;
    y = -r.nextDouble() * b.y;
    length = 30 + r.nextDouble() * 80;
    speed = 700 + r.nextDouble() * 700;
    thickness = 1 + r.nextDouble() * 2.5;
    alpha = 0.3 + r.nextDouble() * 0.4;
  }
}
