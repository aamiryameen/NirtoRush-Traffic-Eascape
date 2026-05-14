import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/vehicle.dart';
import '../../../data/seed/vehicle_catalog.dart';
import '../../../state/economy_provider.dart';
import '../../../state/garage_provider.dart';
import '../../widgets/buttons/neon_button.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/cards/vehicle_card.dart';
import '../../widgets/currency_chip.dart';
import '../../widgets/gradient_background.dart';

class GarageScreen extends ConsumerStatefulWidget {
  const GarageScreen({super.key});

  @override
  ConsumerState<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends ConsumerState<GarageScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final garage = ref.watch(garageProvider);
    final wallet = ref.watch(economyProvider);
    final selected = VehicleCatalog.byId(garage.selectedVehicleId);
    final ownedSelected = garage.selected;
    final effectiveStats =
        ownedSelected.upgrades.applyTo(selected.baseStats);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Garage', style: AppTextStyles.headlineMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(children: [
                CurrencyChip(type: CurrencyType.coins, amount: wallet.coins),
                const SizedBox(width: 6),
                CurrencyChip(type: CurrencyType.gems, amount: wallet.gems),
              ]),
            ),
          ],
          bottom: TabBar(
            controller: _tabs,
            indicatorColor: AppColors.neonPink,
            labelColor: AppColors.neonPink,
            unselectedLabelColor: AppColors.textMuted,
            tabs: const [
              Tab(text: 'Vehicles'),
              Tab(text: 'Upgrade'),
              Tab(text: 'Customize'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: [
            _VehiclesTab(),
            _UpgradeTab(vehicle: selected, effective: effectiveStats),
            _CustomizeTab(vehicle: selected),
          ],
        ),
      ),
    );
  }
}

class _VehiclesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garage = ref.watch(garageProvider);
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: VehicleCatalog.all.length,
      itemBuilder: (context, i) {
        final v = VehicleCatalog.all[i];
        final owned = garage.isOwned(v.id);
        final selected = garage.selectedVehicleId == v.id;
        return VehicleCard(
          vehicle: v,
          owned: owned,
          selected: selected,
          onTap: () async {
            if (owned) {
              await ref.read(garageProvider.notifier).selectVehicle(v.id);
            } else {
              final ok = await ref.read(garageProvider.notifier).buyVehicle(v);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ok ? 'Unlocked ${v.name}!' : 'Not enough currency'),
              ));
            }
          },
        );
      },
    );
  }
}

class _UpgradeTab extends ConsumerWidget {
  const _UpgradeTab({required this.vehicle, required this.effective});
  final Vehicle vehicle;
  final VehicleStats effective;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garage = ref.watch(garageProvider);
    final owned = garage.selected;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(vehicle.name, style: AppTextStyles.headlineLarge),
        const SizedBox(height: 4),
        Text(vehicle.description, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(children: [
            _StatRow(label: 'Speed', value: effective.speed),
            _StatRow(label: 'Acceleration', value: effective.acceleration),
            _StatRow(label: 'Nitro', value: effective.nitro),
            _StatRow(label: 'Handling', value: effective.handling),
            _StatRow(label: 'Durability', value: effective.durability),
          ]),
        ),
        const SizedBox(height: 18),
        Text('Performance Upgrades', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 8),
        _UpgradeRow(
          label: 'Engine',
          icon: Icons.settings_input_component,
          level: owned.upgrades.engineLevel,
          onUpgrade: () => _doUpgrade(context, ref, 'engine'),
        ),
        _UpgradeRow(
          label: 'Turbo',
          icon: Icons.bolt,
          level: owned.upgrades.turboLevel,
          onUpgrade: () => _doUpgrade(context, ref, 'turbo'),
        ),
        _UpgradeRow(
          label: 'Tires',
          icon: Icons.tire_repair,
          level: owned.upgrades.tiresLevel,
          onUpgrade: () => _doUpgrade(context, ref, 'tires'),
        ),
        _UpgradeRow(
          label: 'Brakes',
          icon: Icons.do_disturb_on,
          level: owned.upgrades.brakesLevel,
          onUpgrade: () => _doUpgrade(context, ref, 'brakes'),
        ),
        _UpgradeRow(
          label: 'Suspension',
          icon: Icons.compress,
          level: owned.upgrades.suspensionLevel,
          onUpgrade: () => _doUpgrade(context, ref, 'suspension'),
        ),
      ],
    );
  }

  Future<void> _doUpgrade(BuildContext context, WidgetRef ref, String key) async {
    final cost = 1000 * (1 + (ref.read(garageProvider).selected.upgrades.totalLevel ~/ 5));
    final ok = await ref.read(garageProvider.notifier).upgrade(
          ref.read(garageProvider).selectedVehicleId,
          key,
          cost,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Upgraded! -$cost coins' : 'Cannot upgrade (max or low funds)'),
    ));
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        SizedBox(
          width: 110,
          child: Text(label, style: AppTextStyles.bodyMedium),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: value / 100,
              backgroundColor: AppColors.bgMid,
              valueColor: const AlwaysStoppedAnimation(AppColors.neonPink),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 40, child: Text('$value', style: AppTextStyles.bodyMedium, textAlign: TextAlign.right)),
      ]),
    );
  }
}

class _UpgradeRow extends StatelessWidget {
  const _UpgradeRow({
    required this.label,
    required this.icon,
    required this.level,
    required this.onUpgrade,
  });
  final String label;
  final IconData icon;
  final int level;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          Icon(icon, color: AppColors.neonBlue, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodyLarge),
                Text('Level $level / 10', style: AppTextStyles.caption),
              ],
            ),
          ),
          NeonButton(
            label: 'Upgrade',
            height: 40,
            onTap: level >= 10 ? null : onUpgrade,
          ),
        ]),
      ),
    );
  }
}

class _CustomizeTab extends ConsumerWidget {
  const _CustomizeTab({required this.vehicle});
  final Vehicle vehicle;

  static const _paintColors = [
    0xFFE53935, 0xFF1E88E5, 0xFF43A047, 0xFFFB8C00, 0xFFFFEB3B,
    0xFF8E24AA, 0xFFFFFFFF, 0xFF1A1A1A, 0xFF00ACC1, 0xFFFF80AB,
  ];
  static const _neonColors = [
    0, 0xFF00E0FF, 0xFFFF2A7F, 0xFF22FF88, 0xFFFFE600, 0xFF9C27FF,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garage = ref.watch(garageProvider);
    final c = garage.selected.customization;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Paint', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _paintColors
              .map((color) => _ColorDot(
                    color: Color(color),
                    selected: c.paintColor == color,
                    onTap: () => ref.read(garageProvider.notifier).applyCustomization(
                          garage.selectedVehicleId,
                          c.copyWith(paintColor: color),
                        ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        Text('Neon Underglow', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _neonColors
              .map((color) => _ColorDot(
                    color: color == 0 ? Colors.transparent : Color(color),
                    label: color == 0 ? 'Off' : null,
                    selected: c.neonColor == color,
                    onTap: () => ref.read(garageProvider.notifier).applyCustomization(
                          garage.selectedVehicleId,
                          c.copyWith(neonColor: color),
                        ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          tileColor: AppColors.surface.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          activeThumbColor: AppColors.neonPink,
          value: c.exhaustFlames,
          onChanged: (v) => ref.read(garageProvider.notifier).applyCustomization(
                garage.selectedVehicleId,
                c.copyWith(exhaustFlames: v),
              ),
          title: const Text('Exhaust Flames'),
          subtitle: const Text('Visible during nitro boost'),
        ),
        const SizedBox(height: 12),
        Text('Wheels', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (i) {
            final isSel = c.wheelStyle == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => ref.read(garageProvider.notifier).applyCustomization(
                      garage.selectedVehicleId,
                      c.copyWith(wheelStyle: i),
                    ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.5),
                    border: Border.all(
                      color: isSel ? AppColors.neonPink : AppColors.bgMid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(children: [
                    Icon(Icons.brightness_1, color: Colors.grey[300]),
                    const SizedBox(height: 4),
                    Text('W${i + 1}', style: AppTextStyles.caption),
                  ]),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, this.selected = false, this.onTap, this.label});
  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.neonPink : Colors.white.withValues(alpha: 0.2),
            width: selected ? 3 : 1,
          ),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.neonPink.withValues(alpha: 0.5), blurRadius: 12)]
              : null,
        ),
        child: label != null
            ? Center(
                child: Text(label!,
                    style: AppTextStyles.caption.copyWith(color: Colors.white)),
              )
            : null,
      ),
    );
  }
}
