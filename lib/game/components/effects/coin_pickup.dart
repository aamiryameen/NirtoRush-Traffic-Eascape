import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CoinPickup extends PositionComponent with CollisionCallbacks {
  CoinPickup() : super(size: Vector2(28, 28), anchor: Anchor.center);

  double _spin = 0;
  bool collected = false;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: 14)..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spin += dt * 5;
  }

  @override
  void render(Canvas canvas) {
    if (collected) return;
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    final scaleX = (1.0 - (_spin % 1.0)).abs();
    canvas.scale(0.5 + scaleX * 0.6, 1.0);

    final glow = Paint()
      ..color = const Color(0xFFFFD740).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, 18, glow);

    final base = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFE082), Color(0xFFFFAA00)],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 14));
    canvas.drawCircle(Offset.zero, 14, base);

    final inner = Paint()..color = const Color(0xFFFFD740);
    canvas.drawCircle(Offset.zero, 8, inner);
    canvas.restore();
  }
}
