import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/enums.dart';
import '../../../services/ads_service.dart';
import '../../../state/economy_provider.dart';
import '../../../state/run_provider.dart';
import '../../widgets/buttons/neon_button.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/gradient_background.dart';
import '../gameplay/gameplay_screen.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(runResultProvider);
    if (r == null) {
      return const GradientBackground(child: Scaffold(backgroundColor: Colors.transparent));
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text('RUN ENDED', style: AppTextStyles.caption.copyWith(letterSpacing: 6)),
                const SizedBox(height: 4),
                Text(
                  Formatters.compactNumber(r.score),
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: 84,
                    color: AppColors.neonYellow,
                    shadows: [
                      Shadow(color: AppColors.neonOrange.withValues(alpha: 0.6), blurRadius: 30),
                    ],
                  ),
                ).animate().scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),
                Text('TOTAL SCORE', style: AppTextStyles.caption),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: [
                      _StatTile(
                        label: 'Distance',
                        value: Formatters.distance(r.distance),
                        icon: Icons.straighten,
                        color: AppColors.neonBlue,
                      ),
                      _StatTile(
                        label: 'Top Speed',
                        value: '${(r.topSpeed * 0.625).toStringAsFixed(0)} km/h',
                        icon: Icons.speed,
                        color: AppColors.neonPink,
                      ),
                      _StatTile(
                        label: 'Overtakes',
                        value: '${r.overtakes}',
                        icon: Icons.compare_arrows,
                        color: AppColors.neonGreen,
                      ),
                      _StatTile(
                        label: 'Coins',
                        value: '+${r.coinsEarned}',
                        icon: Icons.monetization_on,
                        color: AppColors.coinGold,
                      ),
                      _StatTile(
                        label: 'XP',
                        value: '+${r.xpEarned}',
                        icon: Icons.stars,
                        color: AppColors.neonPurple,
                      ),
                      _StatTile(
                        label: 'Police Escaped',
                        value: '${r.policeEscaped}',
                        icon: Icons.local_police,
                        color: AppColors.danger,
                      ),
                    ],
                  ),
                ),
                NeonButton(
                  label: '+50% COINS (WATCH AD)',
                  icon: Icons.play_circle,
                  style: NeonButtonStyle.secondary,
                  expand: true,
                  onTap: () async {
                    final ok = await AdsService.instance.showRewarded(AdType.rewarded);
                    if (ok) {
                      final bonus = (r.coinsEarned * 0.5).round();
                      await ref.read(economyProvider.notifier).add(CurrencyType.coins, bonus);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('+$bonus bonus coins!')));
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: NeonButton(
                        label: 'Race Again',
                        icon: Icons.refresh,
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const GameplayScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NeonButton(
                        label: 'Home',
                        style: NeonButtonStyle.ghost,
                        onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withValues(alpha: 0.4),
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.headlineSmall.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ]),
    );
  }
}
