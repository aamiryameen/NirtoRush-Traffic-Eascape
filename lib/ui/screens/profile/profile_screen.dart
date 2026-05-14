import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../state/missions_provider.dart';
import '../../../state/player_provider.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/gradient_background.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final missions = ref.watch(missionsProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Profile', style: AppTextStyles.headlineMedium)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              gradient: AppColors.primaryGradient,
              child: Row(children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white12,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(player?.username ?? 'Racer', style: AppTextStyles.headlineLarge),
                      Text('Level ${player?.level ?? 1}', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (player?.xpToNext ?? 100) == 0
                              ? 0
                              : (player!.xpIntoLevel / player.xpToNext).clamp(0.0, 1.0),
                          backgroundColor: Colors.black26,
                          valueColor: const AlwaysStoppedAnimation(AppColors.neonYellow),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Text('Missions', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            ...missions.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(child: Text(m.title, style: AppTextStyles.bodyLarge)),
                          Text(m.type.name.toUpperCase(),
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.neonBlue)),
                        ]),
                        const SizedBox(height: 4),
                        Text(m.description, style: AppTextStyles.bodySmall),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: m.progressFraction,
                            backgroundColor: AppColors.bgMid,
                            valueColor: const AlwaysStoppedAnimation(AppColors.neonPink),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('${m.progress}/${m.target}',
                                style: AppTextStyles.caption),
                            const Spacer(),
                            if (m.rewardCoins > 0)
                              Text('+${m.rewardCoins} coins  ',
                                  style: AppTextStyles.caption
                                      .copyWith(color: AppColors.coinGold)),
                            if (m.rewardGems > 0)
                              Text('+${m.rewardGems} gems',
                                  style: AppTextStyles.caption
                                      .copyWith(color: AppColors.gemPurple)),
                            if (m.isComplete && m.status.name != 'claimed') ...[
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => ref.read(missionsProvider.notifier).claim(m.id),
                                child: const Text('Claim'),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
