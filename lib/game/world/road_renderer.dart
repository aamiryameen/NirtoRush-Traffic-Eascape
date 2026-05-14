import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_config.dart';

/// Renders the road surface, shoulders, lane lines, and parallax world
/// boundaries. Lane markings scroll based on the world's [scrollOffset].
class RoadRenderer extends PositionComponent {
  RoadRenderer({required this.roadColor, required this.groundColor})
      : super(priority: 0);

  Color roadColor;
  Color groundColor;
  double scrollOffset = 0.0;

  // Cached paints for hot-loop render
  late final Paint _groundPaint = Paint();
  late final Paint _roadPaint = Paint();
  late final Paint _shoulderPaint = Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.6);
  late final Paint _lanePaint = Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.85);
  late final Paint _centerPaint = Paint()..color = const Color(0xFFFFD740);

  @override
  void render(Canvas canvas) {
    final size = this.size;
    _groundPaint.color = groundColor;
    _roadPaint.color = roadColor;

    // Ground (off-road)
    canvas.drawRect(size.toRect(), _groundPaint);

    // Road surface centered
    final roadW = GameConfig.roadWidth;
    final left = (size.x - roadW) / 2;
    final roadRect = Rect.fromLTWH(left, 0, roadW, size.y);
    canvas.drawRect(roadRect, _roadPaint);

    // Shoulders (white lines)
    canvas.drawRect(
      Rect.fromLTWH(left + GameConfig.roadShoulder - 3, 0, 3, size.y),
      _shoulderPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(left + roadW - GameConfig.roadShoulder, 0, 3, size.y),
      _shoulderPaint,
    );

    // Dashed lane lines
    final dashLength = 36.0;
    final gap = 26.0;
    final period = dashLength + gap;
    final laneStartX = left + GameConfig.roadShoulder;
    final yShift = scrollOffset % period;

    for (var lane = 1; lane < GameConfig.laneCount; lane++) {
      final x = laneStartX + lane * GameConfig.laneWidth - 2;
      final isCenter = lane == GameConfig.laneCount ~/ 2;
      final paint = isCenter ? _centerPaint : _lanePaint;
      for (var y = -period + yShift; y < size.y; y += period) {
        canvas.drawRect(Rect.fromLTWH(x, y, 4, dashLength), paint);
      }
    }
  }

  /// World x-coord for the centerline of [lane] (0..laneCount-1).
  double laneCenterX(int lane) {
    final size = this.size;
    final left = (size.x - GameConfig.roadWidth) / 2;
    return left + GameConfig.roadShoulder + GameConfig.laneWidth * (lane + 0.5);
  }

  /// Left/right bounds for road (excluding shoulders).
  double get roadLeft => (size.x - GameConfig.roadWidth) / 2 + GameConfig.roadShoulder;
  double get roadRight => roadLeft + GameConfig.laneWidth * GameConfig.laneCount;
}
