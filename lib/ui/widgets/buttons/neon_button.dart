import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum NeonButtonStyle { primary, secondary, ghost }

class NeonButton extends StatefulWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.style = NeonButtonStyle.primary,
    this.height = 56,
    this.expand = false,
    this.gradient,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final NeonButtonStyle style;
  final double height;
  final bool expand;
  final Gradient? gradient;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onTap == null;
    final gradient = widget.gradient ??
        (widget.style == NeonButtonStyle.primary
            ? AppColors.primaryGradient
            : widget.style == NeonButtonStyle.secondary
                ? AppColors.cyberGradient
                : null);

    final base = AnimatedScale(
      duration: const Duration(milliseconds: 100),
      scale: _pressed ? 0.97 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: widget.height,
        width: widget.expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          gradient: widget.style == NeonButtonStyle.ghost ? null : gradient,
          color: widget.style == NeonButtonStyle.ghost
              ? AppColors.surface.withValues(alpha: 0.5)
              : null,
          border: widget.style == NeonButtonStyle.ghost
              ? Border.all(color: AppColors.neonPink.withValues(alpha: 0.6), width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: disabled || widget.style == NeonButtonStyle.ghost
              ? null
              : [
                  BoxShadow(
                    color: (widget.style == NeonButtonStyle.primary
                            ? AppColors.neonPink
                            : AppColors.neonBlue)
                        .withValues(alpha: 0.45),
                    blurRadius: 24,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
            ],
            Text(
              widget.label.toUpperCase(),
              style: AppTextStyles.button.copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Opacity(
      opacity: disabled ? 0.45 : 1.0,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: base,
      ),
    );
  }
}
