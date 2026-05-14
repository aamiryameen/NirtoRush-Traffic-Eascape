import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/seed/event_seed.dart';
import '../../widgets/buttons/neon_button.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/gradient_background.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = EventSeed.currentEvents();
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Live Events', style: AppTextStyles.headlineMedium)),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, i) {
            final e = events[i];
            final live = e.isLive;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GlassCard(
                gradient: live
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0x9900E0FF), Color(0x669C27FF)],
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(live ? Icons.bolt : Icons.schedule,
                          color: live ? AppColors.neonYellow : AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(live ? 'LIVE NOW' : 'UPCOMING',
                          style: AppTextStyles.caption.copyWith(
                              color: live
                                  ? AppColors.neonYellow
                                  : AppColors.textMuted)),
                      const Spacer(),
                      if (live)
                        Text(
                          'Ends in ${Formatters.duration(e.timeRemaining)}',
                          style: AppTextStyles.caption.copyWith(color: Colors.white),
                        ),
                    ]),
                    const SizedBox(height: 8),
                    Text(e.name, style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 4),
                    Text(e.description, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 10),
                    if (e.milestones.isNotEmpty)
                      ...e.milestones.map((m) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(children: [
                              const Icon(Icons.flag, color: AppColors.neonGreen, size: 16),
                              const SizedBox(width: 6),
                              Text('Score ${m.threshold}',
                                  style: AppTextStyles.bodySmall),
                              const Spacer(),
                              if (m.rewardCoins > 0)
                                Text('+${m.rewardCoins} coins',
                                    style: AppTextStyles.bodySmall
                                        .copyWith(color: AppColors.coinGold)),
                              if (m.rewardGems > 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text('+${m.rewardGems} gems',
                                      style: AppTextStyles.bodySmall
                                          .copyWith(color: AppColors.gemPurple)),
                                ),
                              if (m.rewardVehicleId != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text('Vehicle: ${m.rewardVehicleId}',
                                      style: AppTextStyles.bodySmall
                                          .copyWith(color: AppColors.neonPink)),
                                ),
                            ]),
                          )),
                    const SizedBox(height: 10),
                    NeonButton(
                      label: live ? 'Join Event' : 'Notify Me',
                      expand: true,
                      onTap: live
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('You\'ll be notified when this event starts.')));
                            },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
