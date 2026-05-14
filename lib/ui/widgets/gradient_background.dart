import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Full-screen animated gradient background with subtle moving "neon
/// blob" highlights. Use as the root of every screen for visual consistency.
class GradientBackground extends StatefulWidget {
  const GradientBackground({super.key, required this.child});
  final Widget child;

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.bgGradient),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _BlobPainter(progress: _c.value),
              ),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 2 * pi;
    final blobs = <_Blob>[
      _Blob(
        Offset(size.width * (0.2 + 0.05 * sin(t)),
            size.height * (0.25 + 0.06 * cos(t * 0.6))),
        220,
        AppColors.neonPink.withValues(alpha: 0.32),
      ),
      _Blob(
        Offset(size.width * (0.78 + 0.04 * cos(t * 0.8)),
            size.height * (0.18 + 0.05 * sin(t * 1.1))),
        250,
        AppColors.neonBlue.withValues(alpha: 0.28),
      ),
      _Blob(
        Offset(size.width * (0.55 + 0.06 * sin(t * 1.3)),
            size.height * (0.78 + 0.06 * cos(t))),
        290,
        AppColors.neonPurple.withValues(alpha: 0.30),
      ),
    ];
    for (final b in blobs) {
      final paint = Paint()
        ..color = b.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
      canvas.drawCircle(b.center, b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.progress != progress;
}

class _Blob {
  final Offset center;
  final double radius;
  final Color color;
  _Blob(this.center, this.radius, this.color);
}
