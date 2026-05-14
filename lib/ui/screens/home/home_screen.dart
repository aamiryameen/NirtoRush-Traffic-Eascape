import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/enums.dart';
import '../../../data/seed/vehicle_catalog.dart';
import '../../../state/economy_provider.dart';
import '../../../state/garage_provider.dart';
import '../../../state/player_provider.dart';
import '../../../state/run_provider.dart';
import '../../widgets/buttons/neon_button.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/currency_chip.dart';
import '../../widgets/gradient_background.dart';
import '../battle_pass/battle_pass_screen.dart';
import '../events/events_screen.dart';
import '../garage/garage_screen.dart';
import '../gameplay/gameplay_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../shop/shop_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final wallet = ref.watch(economyProvider);
    final garage = ref.watch(garageProvider);
    final selectedVehicle = VehicleCatalog.byId(garage.selectedVehicleId);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _TopBar(),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CurrencyChip(type: CurrencyType.coins, amount: wallet.coins, onTap: () => _open(context, const ShopScreen())),
                          const SizedBox(width: 8),
                          CurrencyChip(type: CurrencyType.gems, amount: wallet.gems, onTap: () => _open(context, const ShopScreen())),
                          const SizedBox(width: 8),
                          CurrencyChip(type: CurrencyType.fuel, amount: wallet.fuel),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Hero "Play" panel
                      GlassCard(
                        padding: const EdgeInsets.all(18),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0x66FF2A7F), Color(0x6600E0FF)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.flag_circle, color: AppColors.neonYellow, size: 28),
                                const SizedBox(width: 8),
                                Text('Endless Highway',
                                    style: AppTextStyles.headlineMedium),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Race through endless traffic. Stay alive, earn coins, climb the leaderboard.',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Text('Vehicle:',
                                    style: AppTextStyles.caption),
                                const SizedBox(width: 8),
                                Text(selectedVehicle.name,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => _open(context, const GarageScreen()),
                                  child: const Text('Change'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            NeonButton(
                              label: 'PLAY NOW',
                              icon: Icons.play_arrow_rounded,
                              expand: true,
                              onTap: () {
                                ref.read(selectedModeProvider.notifier).state = GameMode.endlessHighway;
                                _open(context, const GameplayScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ModeGrid(),
                      const SizedBox(height: 14),
                      Text('Quick Access', style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 8),
                      _QuickAccess(),
                      const SizedBox(height: 20),
                      _StatsStrip(
                        level: player?.level ?? 1,
                        xpIn: player?.xpIntoLevel ?? 0,
                        xpNext: player?.xpToNext ?? 100,
                        distance: 0,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _TopBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [BoxShadow(color: AppColors.neonPink.withValues(alpha: 0.4), blurRadius: 12)],
          ),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(player?.username ?? 'Racer',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w800)),
            Text('Level ${player?.level ?? 1}',
                style: AppTextStyles.caption.copyWith(color: AppColors.neonBlue)),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
          icon: const Icon(Icons.person_outline, color: Colors.white),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
        ),
      ],
    );
  }
}

class _ModeGrid extends ConsumerWidget {
  static const _modes = [
    (GameMode.timeTrial, Icons.timer, 'Time Trial', AppColors.neonBlue),
    (GameMode.policeEscape, Icons.local_police, 'Police Escape', AppColors.neonRed),
    (GameMode.survival, Icons.favorite_border, 'Survival', AppColors.neonGreen),
    (GameMode.deliveryRush, Icons.local_shipping, 'Delivery', AppColors.neonOrange),
    (GameMode.driftChallenge, Icons.sync_alt, 'Drift', AppColors.neonPurple),
    (GameMode.ghostMode, Icons.cloud, 'Ghost Race', AppColors.neonCyan),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: _modes.map((m) {
        return GlassCard(
          padding: const EdgeInsets.all(10),
          borderColor: m.$4.withValues(alpha: 0.4),
          onTap: () {
            if (m.$1 == GameMode.ghostMode) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Ghost mode requires Supabase replay storage — coming soon.'),
              ));
              return;
            }
            ref.read(selectedModeProvider.notifier).state = m.$1;
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GameplayScreen()));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(m.$2, color: m.$4, size: 28),
              const SizedBox(height: 6),
              Text(m.$3, style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAccess extends StatelessWidget {
  static const _items = [
    (Icons.garage, 'Garage', GarageScreen()),
    (Icons.store, 'Shop', ShopScreen()),
    (Icons.workspace_premium, 'Battle Pass', BattlePassScreen()),
    (Icons.bolt, 'Events', EventsScreen()),
    (Icons.emoji_events, 'Leaderboard', LeaderboardScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _items.map((m) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => m.$3)),
              child: Column(
                children: [
                  Icon(m.$1, color: AppColors.neonBlue, size: 28),
                  const SizedBox(height: 6),
                  Text(m.$2, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.level,
    required this.xpIn,
    required this.xpNext,
    required this.distance,
  });
  final int level, xpIn, xpNext;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final p = xpNext == 0 ? 0.0 : (xpIn / xpNext).clamp(0.0, 1.0);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Level $level',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 8,
              backgroundColor: AppColors.bgMid,
              valueColor: const AlwaysStoppedAnimation(AppColors.neonPink),
            ),
          ),
          const SizedBox(height: 4),
          Text('$xpIn / $xpNext XP',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          if (distance > 0) ...[
            const SizedBox(height: 8),
            Text('Lifetime: ${Formatters.distance(distance)}', style: AppTextStyles.caption),
          ],
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}
