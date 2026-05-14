import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/battle_pass.dart';
import '../../../data/seed/battle_pass_seed.dart';
import '../../../state/battle_pass_provider.dart';
import '../../widgets/buttons/neon_button.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/gradient_background.dart';

class BattlePassScreen extends ConsumerWidget {
  const BattlePassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bp = ref.watch(battlePassProvider);
    final progress = (bp.xp % BattlePassState.xpPerTier) / BattlePassState.xpPerTier;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Battle Pass', style: AppTextStyles.headlineMedium)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              gradient: AppColors.cyberGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bp.seasonName, style: AppTextStyles.displaySmall),
                  const SizedBox(height: 8),
                  Text('Tier ${bp.tier} / ${BattlePassState.maxTier}',
                      style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.black.withValues(alpha: 0.4),
                      valueColor: const AlwaysStoppedAnimation(AppColors.neonYellow),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${bp.xp % BattlePassState.xpPerTier} / ${BattlePassState.xpPerTier} XP to next tier',
                    style: AppTextStyles.caption,
                  ),
                  if (!bp.premiumUnlocked) ...[
                    const SizedBox(height: 12),
                    NeonButton(
                      label: 'Unlock Premium — 1000 gems',
                      icon: Icons.workspace_premium,
                      expand: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Premium unlocks the right column rewards.'),
                        ));
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...BattlePassSeed.tiers.map((pair) {
              final free = pair.$1;
              final premium = pair.$2;
              final unlocked = bp.tier >= free.tier;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: unlocked ? AppColors.neonPink : AppColors.bgMid,
                      ),
                      child: Center(
                        child: Text('${free.tier}',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderColor: unlocked
                            ? AppColors.neonPink.withValues(alpha: 0.5)
                            : Colors.white12,
                        child: Row(children: [
                          const Icon(Icons.card_giftcard, color: Colors.white70),
                          const SizedBox(width: 8),
                          Expanded(child: Text(free.name, style: AppTextStyles.bodyMedium)),
                          if (bp.claimedFreeTiers.contains(free.tier))
                            const Icon(Icons.check, color: AppColors.success)
                          else if (unlocked)
                            TextButton(
                              onPressed: () => ref
                                  .read(battlePassProvider.notifier)
                                  .claimTier(free.tier, premium: false),
                              child: const Text('Claim'),
                            ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderColor: bp.premiumUnlocked
                            ? AppColors.neonYellow.withValues(alpha: 0.5)
                            : Colors.white12,
                        gradient: bp.premiumUnlocked
                            ? null
                            : LinearGradient(colors: [
                                AppColors.surface.withValues(alpha: 0.3),
                                AppColors.bgDark.withValues(alpha: 0.6),
                              ]),
                        child: Row(children: [
                          Icon(Icons.diamond,
                              color: bp.premiumUnlocked
                                  ? AppColors.neonYellow
                                  : Colors.white24),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(premium.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      color: bp.premiumUnlocked
                                          ? Colors.white
                                          : Colors.white38))),
                          if (bp.claimedPremiumTiers.contains(premium.tier))
                            const Icon(Icons.check, color: AppColors.success)
                          else if (unlocked && bp.premiumUnlocked)
                            TextButton(
                              onPressed: () => ref
                                  .read(battlePassProvider.notifier)
                                  .claimTier(premium.tier, premium: true),
                              child: const Text('Claim'),
                            )
                          else if (!bp.premiumUnlocked)
                            const Icon(Icons.lock, color: Colors.white30, size: 18),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
