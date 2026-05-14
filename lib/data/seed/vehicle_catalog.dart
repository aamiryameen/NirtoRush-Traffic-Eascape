import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/vehicle.dart';

/// The full catalog of vehicles. The first vehicle is the player's starter.
class VehicleCatalog {
  VehicleCatalog._();

  static const String starterId = 'compact_civic';

  static const List<Vehicle> all = [
    Vehicle(
      id: 'compact_civic',
      name: 'Civic Sprint',
      category: VehicleCategory.compact,
      rarity: VehicleRarity.common,
      baseStats: VehicleStats(
        speed: 55, acceleration: 60, nitro: 50, handling: 75, durability: 60,
      ),
      priceCoins: 0,
      primaryColor: Color(0xFFE53935),
      secondaryColor: Color(0xFF1A1A1A),
      description: 'Reliable starter coupe. Nimble in tight traffic.',
    ),
    Vehicle(
      id: 'compact_hatch',
      name: 'Hatch Bolt',
      category: VehicleCategory.compact,
      rarity: VehicleRarity.common,
      baseStats: VehicleStats(
        speed: 58, acceleration: 65, nitro: 55, handling: 78, durability: 58,
      ),
      priceCoins: 8000,
      primaryColor: Color(0xFF1E88E5),
      secondaryColor: Color(0xFF0D47A1),
      description: 'Sharper steering, slightly more pop off the line.',
    ),
    Vehicle(
      id: 'sports_supra',
      name: 'Supra Strike',
      category: VehicleCategory.sports,
      rarity: VehicleRarity.rare,
      baseStats: VehicleStats(
        speed: 78, acceleration: 76, nitro: 70, handling: 72, durability: 65,
      ),
      priceCoins: 35000,
      primaryColor: Color(0xFFFFB300),
      secondaryColor: Color(0xFF212121),
      description: 'Tuner classic. Balanced everything.',
    ),
    Vehicle(
      id: 'sports_gtr',
      name: 'Phantom GT-R',
      category: VehicleCategory.sports,
      rarity: VehicleRarity.rare,
      baseStats: VehicleStats(
        speed: 82, acceleration: 80, nitro: 72, handling: 70, durability: 68,
      ),
      priceCoins: 60000,
      primaryColor: Color(0xFF455A64),
      secondaryColor: Color(0xFF1B1B1B),
      description: 'All-wheel grip monster.',
    ),
    Vehicle(
      id: 'muscle_stang',
      name: 'Stallion 5.0',
      category: VehicleCategory.muscle,
      rarity: VehicleRarity.epic,
      baseStats: VehicleStats(
        speed: 84, acceleration: 90, nitro: 88, handling: 55, durability: 80,
      ),
      priceCoins: 95000,
      primaryColor: Color(0xFF1565C0),
      secondaryColor: Color(0xFFFFFFFF),
      description: 'Brute force off the line. Watch the corners.',
    ),
    Vehicle(
      id: 'muscle_charger',
      name: 'Charger Hex',
      category: VehicleCategory.muscle,
      rarity: VehicleRarity.epic,
      baseStats: VehicleStats(
        speed: 86, acceleration: 88, nitro: 90, handling: 50, durability: 85,
      ),
      priceCoins: 120000,
      primaryColor: Color(0xFFFF6F00),
      secondaryColor: Color(0xFF212121),
      description: 'Tank with a turbo.',
    ),
    Vehicle(
      id: 'hyper_bugatti',
      name: 'Vyper Zero',
      category: VehicleCategory.hypercar,
      rarity: VehicleRarity.legendary,
      baseStats: VehicleStats(
        speed: 99, acceleration: 95, nitro: 92, handling: 78, durability: 60,
      ),
      priceCoins: 350000,
      priceGems: 500,
      primaryColor: Color(0xFF00BCD4),
      secondaryColor: Color(0xFF000000),
      description: 'Top-tier speed. Costs a kingdom.',
    ),
    Vehicle(
      id: 'hyper_neonx',
      name: 'Neon X1',
      category: VehicleCategory.hypercar,
      rarity: VehicleRarity.mythic,
      baseStats: VehicleStats(
        speed: 100, acceleration: 98, nitro: 100, handling: 82, durability: 65,
      ),
      priceCoins: 0,
      priceGems: 2500,
      primaryColor: Color(0xFFE91E63),
      secondaryColor: Color(0xFF12005E),
      description: 'Limited-time mythic. Pure neon menace.',
    ),
    Vehicle(
      id: 'suv_prado',
      name: 'Prado Beast',
      category: VehicleCategory.suv,
      rarity: VehicleRarity.rare,
      baseStats: VehicleStats(
        speed: 70, acceleration: 65, nitro: 60, handling: 60, durability: 95,
      ),
      priceCoins: 45000,
      primaryColor: Color(0xFF6D4C41),
      secondaryColor: Color(0xFF3E2723),
      description: 'Soaks up hits. Slow to recover.',
    ),
    Vehicle(
      id: 'truck_hauler',
      name: 'Hauler 18',
      category: VehicleCategory.truck,
      rarity: VehicleRarity.rare,
      baseStats: VehicleStats(
        speed: 65, acceleration: 55, nitro: 50, handling: 45, durability: 100,
      ),
      priceCoins: 70000,
      primaryColor: Color(0xFF455A64),
      secondaryColor: Color(0xFF263238),
      description: 'Plows through traffic. Police hate it.',
    ),
  ];

  static Vehicle byId(String id) => all.firstWhere((v) => v.id == id);
}
