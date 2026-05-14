import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../game_config.dart';
import 'car_painter.dart';

enum TrafficKind { sedan, suv, truck, bus, bike, sportsCar }

class TrafficCar extends PositionComponent with CollisionCallbacks {
  TrafficCar({
    required this.kind,
    required this.speed,
    required this.lane,
    required this.bodyColor,
  })  : accentColor = Colors.black,
        super(
          size: _sizeForKind(kind),
          anchor: Anchor.center,
        );

  final TrafficKind kind;
  final Color bodyColor;
  final Color accentColor;
  double speed;
  int lane;

  bool counted = false; // overtake bookkeeping

  static Vector2 _sizeForKind(TrafficKind k) {
    switch (k) {
      case TrafficKind.sedan:
        return Vector2(GameConfig.trafficCarWidth, GameConfig.trafficCarHeight);
      case TrafficKind.sportsCar:
        return Vector2(GameConfig.trafficCarWidth * 0.95, GameConfig.trafficCarHeight * 0.95);
      case TrafficKind.suv:
        return Vector2(GameConfig.trafficCarWidth * 1.05, GameConfig.trafficCarHeight * 1.10);
      case TrafficKind.truck:
        return Vector2(GameConfig.trafficCarWidth * 1.0, GameConfig.trafficCarHeight * 1.55);
      case TrafficKind.bus:
        return Vector2(GameConfig.trafficCarWidth * 1.05, GameConfig.trafficCarHeight * 1.95);
      case TrafficKind.bike:
        return Vector2(GameConfig.trafficCarWidth * 0.45, GameConfig.trafficCarHeight * 0.85);
    }
  }

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
      body: bodyColor,
      accent: accentColor,
      isBus: kind == TrafficKind.bus,
      isTruck: kind == TrafficKind.truck,
      isBike: kind == TrafficKind.bike,
    );
  }

  static TrafficKind weightedRandom(Random r) {
    final roll = r.nextDouble();
    if (roll < 0.45) return TrafficKind.sedan;
    if (roll < 0.65) return TrafficKind.suv;
    if (roll < 0.78) return TrafficKind.sportsCar;
    if (roll < 0.88) return TrafficKind.truck;
    if (roll < 0.95) return TrafficKind.bus;
    return TrafficKind.bike;
  }

  static double speedForKind(TrafficKind kind, Random r) {
    final base = GameConfig.trafficBaseSpeed;
    switch (kind) {
      case TrafficKind.sedan:
        return base + r.nextDouble() * 60;
      case TrafficKind.suv:
        return base + r.nextDouble() * 40;
      case TrafficKind.sportsCar:
        return base + 60 + r.nextDouble() * 80;
      case TrafficKind.truck:
        return base - 40 + r.nextDouble() * 30;
      case TrafficKind.bus:
        return base - 30 + r.nextDouble() * 25;
      case TrafficKind.bike:
        return base + 30 + r.nextDouble() * 70;
    }
  }
}
