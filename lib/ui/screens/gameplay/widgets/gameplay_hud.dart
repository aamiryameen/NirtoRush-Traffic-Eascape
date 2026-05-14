import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../game/nitro_game.dart';

class GameplayHUD extends StatelessWidget {
  const GameplayHUD({super.key, required this.snapshot, required this.onPause});

  final GameStateSnapshot snapshot;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Top bar: distance, coins, pause
            Row(
              children: [
                _HudChip(
                  icon: Icons.straighten,
                  label: Formatters.distance(snapshot.distance),
                  color: AppColors.neonBlue,
                ),
                const SizedBox(width: 8),
                _HudChip(
                  icon: Icons.monetization_on,
                  label: '${snapshot.coins}',
                  color: AppColors.coinGold,
                ),
                const SizedBox(width: 8),
                _HudChip(
                  icon: Icons.local_police,
                  label: 'WL ${snapshot.wantedLevel}',
                  color: snapshot.wantedLevel > 0 ? AppColors.danger : AppColors.textMuted,
                ),
                const Spacer(),
                _PauseButton(onTap: onPause),
              ],
            ),
            const Spacer(),
            // Bottom-right: speedometer
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Nitro bar (vertical)
                Container(
                  width: 14,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.bgMid.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: AppColors.neonOrange.withValues(alpha: 0.6), width: 1),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      FractionallySizedBox(
                        heightFactor: (snapshot.nitroSeconds / 4.0).clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.nitroGradient,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonOrange.withValues(alpha: 0.7),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('SCORE', style: AppTextStyles.caption),
                    Text(
                      Formatters.compactNumber(snapshot.score),
                      style: AppTextStyles.headlineMedium.copyWith(color: AppColors.neonYellow),
                    ),
                    const SizedBox(height: 6),
                    Text('KMH', style: AppTextStyles.caption),
                    Text(
                      snapshot.speedKmh.toStringAsFixed(0),
                      style: AppTextStyles.speedometer.copyWith(
                        color: snapshot.speedKmh > 250
                            ? AppColors.neonPink
                            : AppColors.textPrimary,
                        shadows: [
                          Shadow(
                              color: AppColors.neonPink.withValues(alpha: 0.6),
                              blurRadius: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgDarkest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.bgDarkest.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.neonPink.withValues(alpha: 0.6)),
        ),
        child: const Icon(Icons.pause, color: Colors.white, size: 22),
      ),
    );
  }
}
