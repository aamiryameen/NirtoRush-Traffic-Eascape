import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// On-screen controls: left half = steering pad, bottom-right = nitro,
/// bottom-left small = brake. Designed for thumbs at the bottom of the screen.
class TouchControls extends StatefulWidget {
  const TouchControls({
    super.key,
    required this.onSteer,
    required this.onBrake,
    required this.onNitro,
  });

  final void Function(double) onSteer; // -1..1
  final void Function(bool) onBrake;
  final void Function(bool) onNitro;

  @override
  State<TouchControls> createState() => _TouchControlsState();
}

class _TouchControlsState extends State<TouchControls> {
  bool _braking = false;
  bool _nitroPressed = false;

  // Direct finger-following steering: each frame we report how far the finger
  // moved horizontally since the last frame. The game moves the car by that
  // same amount, so the car tracks the finger 1:1 and stops when it stops —
  // no sliding, no overshoot.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen steering: finger horizontal delta drives the car.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (d) {
              // Report the per-frame finger delta in pixels.
              widget.onSteer(d.delta.dx);
            },
            onPanEnd: (_) {
              widget.onSteer(0);
            },
            onPanCancel: () {
              widget.onSteer(0);
            },
          ),
        ),

        // Brake — bottom-left
        Positioned(
          left: 24,
          bottom: 24,
          child: _PadButton(
            icon: Icons.do_disturb_on,
            color: AppColors.neonRed,
            active: _braking,
            onDown: () {
              setState(() => _braking = true);
              widget.onBrake(true);
            },
            onUp: () {
              setState(() => _braking = false);
              widget.onBrake(false);
            },
          ),
        ),

        // Nitro — bottom-right
        Positioned(
          right: 24,
          bottom: 24,
          child: _PadButton(
            icon: Icons.bolt,
            color: AppColors.neonOrange,
            active: _nitroPressed,
            large: true,
            onDown: () {
              setState(() => _nitroPressed = true);
              widget.onNitro(true);
            },
            onUp: () {
              setState(() => _nitroPressed = false);
              widget.onNitro(false);
            },
          ),
        ),
      ],
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({
    required this.icon,
    required this.color,
    required this.active,
    required this.onDown,
    required this.onUp,
    this.large = false,
  });

  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 96.0 : 76.0;
    return Listener(
      onPointerDown: (_) => onDown(),
      onPointerUp: (_) => onUp(),
      onPointerCancel: (_) => onUp(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: active ? 0.95 : 0.7),
              color.withValues(alpha: 0.2),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: active ? 0.8 : 0.4),
              blurRadius: active ? 30 : 18,
              spreadRadius: active ? 2 : 0,
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: large ? 40 : 30),
      ),
    );
  }
}
