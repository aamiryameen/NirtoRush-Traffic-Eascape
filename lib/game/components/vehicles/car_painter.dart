import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Procedural car renderer — draws a stylized vehicle from colors only.
/// Replace with sprite renderer once art assets ship; the API surface
/// (width, height, primaryColor, secondaryColor) stays identical.
class CarPainter {
  static void paint(
    Canvas canvas,
    Vector2 size, {
    required Color body,
    required Color accent,
    bool isPolice = false,
    bool isBus = false,
    bool isTruck = false,
    bool isBike = false,
    Color? neonGlow,
    bool exhaustFlames = false,
  }) {
    final w = size.x;
    final h = size.y;
    final cx = w / 2;

    // Shadow underneath
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, h * 0.96), width: w * 0.92, height: h * 0.18), shadowPaint);

    // Neon glow (under-glow effect)
    if (neonGlow != null) {
      final glowPaint = Paint()
        ..color = neonGlow.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-4, h * 0.15, w + 8, h * 0.78),
          const Radius.circular(18),
        ),
        glowPaint,
      );
    }

    if (isBike) {
      _paintBike(canvas, w, h, body, accent);
      return;
    }

    // Main body
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.06, h * 0.10, w * 0.88, h * 0.82),
      Radius.circular(isTruck || isBus ? 8 : 18),
    );

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          body,
          Color.lerp(body, Colors.black, 0.35) ?? body,
        ],
      ).createShader(bodyRRect.outerRect);
    canvas.drawRRect(bodyRRect, bodyPaint);

    // Highlight strip
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.13, w * 0.80, h * 0.05),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.15),
    );

    // Windows
    final windowPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2C3E50), Color(0xFF1A1A1A)],
      ).createShader(Rect.fromLTWH(w * 0.12, h * 0.20, w * 0.76, h * 0.20));

    if (isBus) {
      // Multiple windows
      for (var i = 0; i < 4; i++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * (0.12 + 0.20 * i), h * 0.18, w * 0.16, h * 0.20),
            const Radius.circular(4),
          ),
          windowPaint,
        );
      }
    } else if (isTruck) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.18, h * 0.16, w * 0.64, h * 0.20),
          const Radius.circular(6),
        ),
        windowPaint,
      );
      // Cargo separator
      canvas.drawRect(
        Rect.fromLTWH(w * 0.10, h * 0.40, w * 0.80, 4),
        Paint()..color = Colors.black.withValues(alpha: 0.6),
      );
    } else {
      // Front windshield
      final winFront = Path()
        ..moveTo(w * 0.14, h * 0.36)
        ..lineTo(w * 0.86, h * 0.36)
        ..lineTo(w * 0.80, h * 0.20)
        ..lineTo(w * 0.20, h * 0.20)
        ..close();
      canvas.drawPath(winFront, windowPaint);
      // Rear windshield
      final winRear = Path()
        ..moveTo(w * 0.14, h * 0.66)
        ..lineTo(w * 0.86, h * 0.66)
        ..lineTo(w * 0.80, h * 0.82)
        ..lineTo(w * 0.20, h * 0.82)
        ..close();
      canvas.drawPath(winRear, windowPaint);
    }

    // Wheels
    final wheelPaint = Paint()..color = const Color(0xFF111111);
    final wheelRimPaint = Paint()..color = accent;
    final wheelRadius = isTruck || isBus ? h * 0.07 : h * 0.06;
    final wheelY1 = h * 0.22;
    final wheelY2 = h * 0.78;
    final wheelXL = w * 0.04;
    final wheelXR = w * 0.86;

    for (final pair in [
      [wheelXL, wheelY1],
      [wheelXR, wheelY1],
      [wheelXL, wheelY2],
      [wheelXR, wheelY2],
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pair[0], pair[1] - wheelRadius / 2, w * 0.10, wheelRadius * 2),
          const Radius.circular(4),
        ),
        wheelPaint,
      );
      canvas.drawCircle(
        Offset(pair[0] + w * 0.05, pair[1] + wheelRadius / 2),
        wheelRadius * 0.7,
        wheelRimPaint,
      );
    }

    // Headlights
    final headPaint = Paint()
      ..color = const Color(0xFFFFF6C8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.08, w * 0.18, h * 0.04),
        const Radius.circular(4),
      ),
      headPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.70, h * 0.08, w * 0.18, h * 0.04),
        const Radius.circular(4),
      ),
      headPaint,
    );

    // Tail lights
    final tailPaint = Paint()..color = const Color(0xFFFF1744);
    canvas.drawRect(Rect.fromLTWH(w * 0.10, h * 0.90, w * 0.20, h * 0.03), tailPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.70, h * 0.90, w * 0.20, h * 0.03), tailPaint);

    // Police lightbar
    if (isPolice) {
      final flash = (DateTime.now().millisecondsSinceEpoch % 400 < 200);
      final lightPaint = Paint()
        ..color = flash ? const Color(0xFFFF1744) : const Color(0xFF2979FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.18, h * 0.46, w * 0.64, h * 0.06),
          const Radius.circular(6),
        ),
        lightPaint,
      );
    }

    // Exhaust flames
    if (exhaustFlames) {
      final flamePaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE600), Color(0xFFFF6A00), Color(0xFFFF1744)],
        ).createShader(Rect.fromLTWH(w * 0.30, h * 0.95, w * 0.40, h * 0.18))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      final flamePath = Path()
        ..moveTo(w * 0.35, h * 0.94)
        ..lineTo(w * 0.50, h * 1.12)
        ..lineTo(w * 0.65, h * 0.94)
        ..close();
      canvas.drawPath(flamePath, flamePaint);
    }
  }

  static void _paintBike(Canvas canvas, double w, double h, Color body, Color accent) {
    // Frame
    final framePaint = Paint()..color = body;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, h * 0.15, w * 0.50, h * 0.70),
        const Radius.circular(18),
      ),
      framePaint,
    );
    // Wheels
    final wheelPaint = Paint()..color = const Color(0xFF111111);
    canvas.drawCircle(Offset(w * 0.50, h * 0.12), w * 0.20, wheelPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.88), w * 0.20, wheelPaint);
    // Rider
    final riderPaint = Paint()..color = accent;
    canvas.drawCircle(Offset(w * 0.50, h * 0.40), w * 0.16, riderPaint);
  }
}
