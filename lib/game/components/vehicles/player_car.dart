import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../game_config.dart';
import 'car_painter.dart';
import 'police_car.dart';
import 'traffic_car.dart';

class PlayerCar extends PositionComponent with CollisionCallbacks {
  PlayerCar({
    required this.bodyColor,
    required this.accentColor,
    this.neonColor,
    this.exhaustFlames = false,
    this.onCollide,
  }) : super(
          size: Vector2(GameConfig.playerCarWidth, GameConfig.playerCarHeight),
          anchor: Anchor.center,
        );

  Color bodyColor;
  Color accentColor;
  Color? neonColor;
  bool exhaustFlames;

  /// Called when this car collides with traffic/police. Wired by the game.
  void Function()? onCollide;

  /// Used by external state to know when collision happened.
  bool collided = false;
  double tilt = 0.0; // -1..1 for visual lean during steering

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(size.x * 0.78, size.y * 0.88),
      position: Vector2(size.x * 0.11, size.y * 0.06),
    )..collisionType = CollisionType.active);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (collided) return;
    // Only solid vehicles are deadly. Coins (and any other passive pickups)
    // are handled by the game's own pickup logic, not by crashing.
    final hitParent = other is ShapeHitbox ? other.parent : other;
    if (hitParent is! TrafficCar && hitParent is! PoliceCar) return;
    collided = true;
    onCollide?.call();
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(tilt * 0.10);
    canvas.translate(-size.x / 2, -size.y / 2);
    CarPainter.paint(
      canvas,
      size,
      body: bodyColor,
      accent: accentColor,
      neonGlow: neonColor,
      exhaustFlames: exhaustFlames,
    );
    canvas.restore();
  }
}
