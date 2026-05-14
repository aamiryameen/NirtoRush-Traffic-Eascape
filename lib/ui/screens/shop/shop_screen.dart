import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/enums.dart';
import '../../../services/ads_service.dart';
import '../../../state/economy_provider.dart';
import '../../widgets/buttons/neon_button.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/currency_chip.dart';
import '../../widgets/gradient_background.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  static const _coinPacks = [
    (1000, 0.99, 'Starter', false),
    (5500, 4.99, 'Standard', false),
    (12000, 9.99, 'Mega', true),
    (30000, 19.99, 'Pro', false),
    (75000, 49.99, 'Legend', false),
  ];

  static const _gemPacks = [
    (60, 0.99, 'Small', false),
    (320, 4.99, 'Medium', false),
    (700, 9.99, 'Best Value', true),
    (1800, 19.99, 'Premium', false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(economyProvider);
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Shop', style: AppTextStyles.headlineMedium),
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
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _DailyRewardCard(),
            const SizedBox(height: 16),
            _RewardedAdCard(),
            const SizedBox(height: 20),
            Text('Coin Packs', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            ..._coinPacks.map((p) => _PackCard(
                  amount: p.$1,
                  price: p.$2,
                  label: p.$3,
                  hot: p.$4,
                  currency: CurrencyType.coins,
                )),
            const SizedBox(height: 20),
            Text('Gem Packs', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            ..._gemPacks.map((p) => _PackCard(
                  amount: p.$1,
                  price: p.$2,
                  label: p.$3,
                  hot: p.$4,
                  currency: CurrencyType.gems,
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _DailyRewardCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x99FFC940), Color(0x66FF6A00)],
      ),
      child: Row(children: [
        const Icon(Icons.card_giftcard, color: Colors.white, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily Reward', style: AppTextStyles.headlineSmall),
              Text('Claim today\'s bonus coins', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        NeonButton(
          label: 'Claim',
          height: 44,
          onTap: () async {
            await ref.read(economyProvider.notifier).add(CurrencyType.coins, 250);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('+250 coins')));
          },
        ),
      ]),
    );
  }
}

class _RewardedAdCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x9900E0FF), Color(0x669C27FF)],
      ),
      child: Row(children: [
        const Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Watch & Earn', style: AppTextStyles.headlineSmall),
              Text('Up to +500 coins per ad', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        NeonButton(
          label: 'Watch',
          height: 44,
          style: NeonButtonStyle.secondary,
          onTap: () async {
            final ok = await AdsService.instance.showRewarded(AdType.rewarded);
            if (!ok) return;
            await ref.read(economyProvider.notifier).add(CurrencyType.coins, 500);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('+500 coins')));
          },
        ),
      ]),
    );
  }
}

class _PackCard extends ConsumerWidget {
  const _PackCard({
    required this.amount,
    required this.price,
    required this.label,
    required this.hot,
    required this.currency,
  });

  final int amount;
  final double price;
  final String label;
  final bool hot;
  final CurrencyType currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        borderColor: hot ? AppColors.neonYellow.withValues(alpha: 0.7) : null,
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Icon(
            currency == CurrencyType.coins ? Icons.monetization_on : Icons.diamond,
            color: currency == CurrencyType.coins ? AppColors.coinGold : AppColors.gemPurple,
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('$amount ${currency.name}',
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w800)),
                    if (hot) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.neonYellow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('HOT',
                            style: AppTextStyles.caption.copyWith(color: Colors.black)),
                      ),
                    ],
                  ],
                ),
                Text(label, style: AppTextStyles.caption),
              ],
            ),
          ),
          NeonButton(
            label: '\$${price.toStringAsFixed(2)}',
            height: 44,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('In-app billing requires Play Console + billing SDK setup.'),
              ));
            },
          ),
        ]),
      ),
    );
  }
}
