import 'package:flame/components.dart' show Vector2;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/vehicle.dart';
import '../../../game/components/vehicles/car_painter.dart';
import 'glass_card.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.owned,
    required this.selected,
    this.onTap,
  });

  final Vehicle vehicle;
  final bool owned;
  final bool selected;
  final VoidCallback? onTap;

  Color get _rarityColor => switch (vehicle.rarity) {
        VehicleRarity.common => AppColors.rarityCommon,
        VehicleRarity.rare => AppColors.rarityRare,
        VehicleRarity.epic => AppColors.rarityEpic,
        VehicleRarity.legendary => AppColors.rarityLegendary,
        VehicleRarity.mythic => AppColors.rarityMythic,
      };

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      borderColor: selected ? AppColors.neonPink : _rarityColor.withValues(alpha: 0.4),
      padding: const EdgeInsets.all(12),
      gradient: selected
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _rarityColor.withValues(alpha: 0.25),
                AppColors.surface.withValues(alpha: 0.55),
              ],
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Render the car
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.1,
              child: CustomPaint(
                painter: _CarPreviewPainter(vehicle: vehicle),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _rarityColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  vehicle.rarity.name.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(color: _rarityColor),
                ),
              ),
              const Spacer(),
              if (owned)
                const Icon(Icons.check_circle, color: AppColors.success, size: 18)
              else
                Row(children: [
                  if (vehicle.priceCoins > 0) ...[
                    const Icon(Icons.monetization_on,
                        color: AppColors.coinGold, size: 14),
                    const SizedBox(width: 2),
                    Text('${vehicle.priceCoins}',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.coinGold)),
                  ],
                  if (vehicle.priceGems > 0) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.diamond, color: AppColors.gemPurple, size: 14),
                    const SizedBox(width: 2),
                    Text('${vehicle.priceGems}',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.gemPurple)),
                  ],
                ]),
            ],
          ),
          const SizedBox(height: 4),
          Text(vehicle.name, style: AppTextStyles.headlineSmall, maxLines: 1),
          Text(
            vehicle.category.name.toUpperCase(),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _CarPreviewPainter extends CustomPainter {
  _CarPreviewPainter({required this.vehicle});
  final Vehicle vehicle;

  @override
  void paint(Canvas canvas, Size size) {
    // Frame background
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      bgPaint,
    );
    // Car centered
    final carW = size.width * 0.55;
    final carH = carW * 1.7;
    final offsetX = (size.width - carW) / 2;
    final offsetY = (size.height - carH) / 2;
    canvas.save();
    canvas.translate(offsetX, offsetY);
    CarPainter.paint(
      canvas,
      Vector2(carW, carH),
      body: vehicle.primaryColor,
      accent: vehicle.secondaryColor,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CarPreviewPainter old) => old.vehicle.id != vehicle.id;
}
