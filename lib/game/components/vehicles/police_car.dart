import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../game_config.dart';
import 'car_painter.dart';

class PoliceCar extends PositionComponent with CollisionCallbacks {
  PoliceCar({required this.speed, required this.lane})
      : super(
          size: Vector2(GameConfig.trafficCarWidth, GameConfig.trafficCarHeight),
          anchor: Anchor.center,
        );

  double speed;
  int lane;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(size.x * 0.82, size.y * 0.90),
      position: Vector2(size.x * 0.09, size.y * 0.05),
    )..collisionType = CollisionType.passive);
  }

  @override
  void render(Canvas canvas) {
    CarPainter.paint(
      canvas,
      size,
      body: const Color(0xFF1A237E),
      accent: Colors.white,
      isPolice: true,
    );
  }
}
