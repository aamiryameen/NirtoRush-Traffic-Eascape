import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../widgets/buttons/neon_button.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onQuit,
  });

  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PAUSED', style: AppTextStyles.displayLarge),
              const SizedBox(height: 8),
              Text('Take a breath, racer.', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 32),
              SizedBox(
                width: 260,
                child: Column(
                  children: [
                    NeonButton(label: 'Resume', icon: Icons.play_arrow, expand: true, onTap: onResume),
                    const SizedBox(height: 12),
                    NeonButton(
                      label: 'Restart',
                      icon: Icons.refresh,
                      style: NeonButtonStyle.secondary,
                      expand: true,
                      onTap: onRestart,
                    ),
                    const SizedBox(height: 12),
                    NeonButton(
                      label: 'Quit',
                      icon: Icons.exit_to_app,
                      style: NeonButtonStyle.ghost,
                      expand: true,
                      onTap: onQuit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
