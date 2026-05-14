import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/enums.dart';

class CurrencyChip extends StatelessWidget {
  const CurrencyChip({super.key, required this.type, required this.amount, this.onTap});

  final CurrencyType type;
  final int amount;
  final VoidCallback? onTap;

  IconData get _icon => switch (type) {
        CurrencyType.coins => Icons.monetization_on,
        CurrencyType.gems => Icons.diamond,
        CurrencyType.fuel => Icons.local_gas_station,
        CurrencyType.eventTokens => Icons.bolt,
      };

  Color get _accent => switch (type) {
        CurrencyType.coins => AppColors.coinGold,
        CurrencyType.gems => AppColors.gemPurple,
        CurrencyType.fuel => AppColors.fuelOrange,
        CurrencyType.eventTokens => AppColors.eventToken,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _accent.withValues(alpha: 0.4), width: 1),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.18),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, color: _accent, size: 18),
            const SizedBox(width: 6),
            Text(
              Formatters.compactNumber(amount),
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.add_circle, color: _accent, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
