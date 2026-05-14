import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ParticleBurst extends PositionComponent {
  ParticleBurst({
    required Vector2 origin,
    required this.color,
    int count = 24,
    this.spread = 80,
    this.life = 0.6,
  }) : super(position: origin) {
    final r = Random();
    _particles = List.generate(count, (_) {
      final angle = r.nextDouble() * pi * 2;
      final v = 60 + r.nextDouble() * spread;
      return _P(
        Offset.zero,
        Offset(cos(angle) * v, sin(angle) * v),
        1.0,
        3 + r.nextDouble() * 3,
      );
    });
  }

  final Color color;
  final double spread;
  final double life;
  late List<_P> _particles;
  double _age = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    for (final p in _particles) {
      p.pos += p.vel * dt;
      p.vel = p.vel * (1 - dt * 1.4); // drag
      p.alpha = (1 - _age / life).clamp(0.0, 1.0);
    }
    if (_age >= life) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      canvas.drawCircle(
        p.pos,
        p.radius,
        Paint()
          ..color = color.withValues(alpha: p.alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }
}

class _P {
  Offset pos;
  Offset vel;
  double alpha;
  double radius;
  _P(this.pos, this.vel, this.alpha, this.radius);
}
