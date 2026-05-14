import 'package:flutter/material.dart';
import 'enums.dart';

/// Tuning stats for a vehicle. All 0..100 scale.
class VehicleStats {
  final int speed;
  final int acceleration;
  final int nitro;
  final int handling;
  final int durability;

  const VehicleStats({
    required this.speed,
    required this.acceleration,
    required this.nitro,
    required this.handling,
    required this.durability,
  });

  int get overall => ((speed + acceleration + nitro + handling + durability) / 5).round();

  VehicleStats copyWith({
    int? speed,
    int? acceleration,
    int? nitro,
    int? handling,
    int? durability,
  }) =>
      VehicleStats(
        speed: speed ?? this.speed,
        acceleration: acceleration ?? this.acceleration,
        nitro: nitro ?? this.nitro,
        handling: handling ?? this.handling,
        durability: durability ?? this.durability,
      );

  Map<String, dynamic> toJson() => {
        'speed': speed,
        'acceleration': acceleration,
        'nitro': nitro,
        'handling': handling,
        'durability': durability,
      };

  factory VehicleStats.fromJson(Map<String, dynamic> j) => VehicleStats(
        speed: j['speed'] as int,
        acceleration: j['acceleration'] as int,
        nitro: j['nitro'] as int,
        handling: j['handling'] as int,
        durability: j['durability'] as int,
      );
}

/// Visual customization (paint, wheels, etc).
class VehicleCustomization {
  final int paintColor; // ARGB
  final int neonColor; // ARGB, 0 = off
  final int wheelStyle; // 0..N preset
  final int spoilerStyle;
  final int decalStyle;
  final int windowTint; // 0..100
  final bool exhaustFlames;

  const VehicleCustomization({
    this.paintColor = 0xFFE53935,
    this.neonColor = 0,
    this.wheelStyle = 0,
    this.spoilerStyle = 0,
    this.decalStyle = 0,
    this.windowTint = 30,
    this.exhaustFlames = false,
  });

  VehicleCustomization copyWith({
    int? paintColor,
    int? neonColor,
    int? wheelStyle,
    int? spoilerStyle,
    int? decalStyle,
    int? windowTint,
    bool? exhaustFlames,
  }) =>
      VehicleCustomization(
        paintColor: paintColor ?? this.paintColor,
        neonColor: neonColor ?? this.neonColor,
        wheelStyle: wheelStyle ?? this.wheelStyle,
        spoilerStyle: spoilerStyle ?? this.spoilerStyle,
        decalStyle: decalStyle ?? this.decalStyle,
        windowTint: windowTint ?? this.windowTint,
        exhaustFlames: exhaustFlames ?? this.exhaustFlames,
      );

  Map<String, dynamic> toJson() => {
        'paintColor': paintColor,
        'neonColor': neonColor,
        'wheelStyle': wheelStyle,
        'spoilerStyle': spoilerStyle,
        'decalStyle': decalStyle,
        'windowTint': windowTint,
        'exhaustFlames': exhaustFlames,
      };

  factory VehicleCustomization.fromJson(Map<String, dynamic> j) => VehicleCustomization(
        paintColor: j['paintColor'] as int? ?? 0xFFE53935,
        neonColor: j['neonColor'] as int? ?? 0,
        wheelStyle: j['wheelStyle'] as int? ?? 0,
        spoilerStyle: j['spoilerStyle'] as int? ?? 0,
        decalStyle: j['decalStyle'] as int? ?? 0,
        windowTint: j['windowTint'] as int? ?? 30,
        exhaustFlames: j['exhaustFlames'] as bool? ?? false,
      );
}

/// Performance upgrades (engine, turbo, tires, brakes, suspension).
class VehicleUpgrades {
  final int engineLevel; // 0..10
  final int turboLevel;
  final int tiresLevel;
  final int brakesLevel;
  final int suspensionLevel;

  const VehicleUpgrades({
    this.engineLevel = 0,
    this.turboLevel = 0,
    this.tiresLevel = 0,
    this.brakesLevel = 0,
    this.suspensionLevel = 0,
  });

  int get totalLevel =>
      engineLevel + turboLevel + tiresLevel + brakesLevel + suspensionLevel;

  /// Each upgrade level adds +2 to its stat (capped at 100 elsewhere).
  VehicleStats applyTo(VehicleStats base) => VehicleStats(
        speed: (base.speed + engineLevel * 2).clamp(0, 100),
        acceleration: (base.acceleration + engineLevel * 2).clamp(0, 100),
        nitro: (base.nitro + turboLevel * 2).clamp(0, 100),
        handling: (base.handling + tiresLevel + suspensionLevel).clamp(0, 100),
        durability: (base.durability + brakesLevel + suspensionLevel).clamp(0, 100),
      );

  VehicleUpgrades copyWith({
    int? engineLevel,
    int? turboLevel,
    int? tiresLevel,
    int? brakesLevel,
    int? suspensionLevel,
  }) =>
      VehicleUpgrades(
        engineLevel: engineLevel ?? this.engineLevel,
        turboLevel: turboLevel ?? this.turboLevel,
        tiresLevel: tiresLevel ?? this.tiresLevel,
        brakesLevel: brakesLevel ?? this.brakesLevel,
        suspensionLevel: suspensionLevel ?? this.suspensionLevel,
      );

  Map<String, dynamic> toJson() => {
        'engineLevel': engineLevel,
        'turboLevel': turboLevel,
        'tiresLevel': tiresLevel,
        'brakesLevel': brakesLevel,
        'suspensionLevel': suspensionLevel,
      };

  factory VehicleUpgrades.fromJson(Map<String, dynamic> j) => VehicleUpgrades(
        engineLevel: j['engineLevel'] as int? ?? 0,
        turboLevel: j['turboLevel'] as int? ?? 0,
        tiresLevel: j['tiresLevel'] as int? ?? 0,
        brakesLevel: j['brakesLevel'] as int? ?? 0,
        suspensionLevel: j['suspensionLevel'] as int? ?? 0,
      );
}

/// Vehicle template (catalog entry, immutable).
class Vehicle {
  final String id;
  final String name;
  final VehicleCategory category;
  final VehicleRarity rarity;
  final VehicleStats baseStats;
  final int priceCoins;
  final int priceGems;
  final Color primaryColor;
  final Color secondaryColor;
  final String description;

  const Vehicle({
    required this.id,
    required this.name,
    required this.category,
    required this.rarity,
    required this.baseStats,
    this.priceCoins = 0,
    this.priceGems = 0,
    this.primaryColor = const Color(0xFFE53935),
    this.secondaryColor = const Color(0xFF1A1A1A),
    this.description = '',
  });
}

/// Player-owned instance of a vehicle.
class OwnedVehicle {
  final String vehicleId;
  final VehicleUpgrades upgrades;
  final VehicleCustomization customization;
  final DateTime unlockedAt;

  const OwnedVehicle({
    required this.vehicleId,
    this.upgrades = const VehicleUpgrades(),
    this.customization = const VehicleCustomization(),
    required this.unlockedAt,
  });

  OwnedVehicle copyWith({
    VehicleUpgrades? upgrades,
    VehicleCustomization? customization,
  }) =>
      OwnedVehicle(
        vehicleId: vehicleId,
        upgrades: upgrades ?? this.upgrades,
        customization: customization ?? this.customization,
        unlockedAt: unlockedAt,
      );

  Map<String, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'upgrades': upgrades.toJson(),
        'customization': customization.toJson(),
        'unlockedAt': unlockedAt.toIso8601String(),
      };

  factory OwnedVehicle.fromJson(Map<String, dynamic> j) => OwnedVehicle(
        vehicleId: j['vehicleId'] as String,
        upgrades: VehicleUpgrades.fromJson(j['upgrades'] as Map<String, dynamic>),
        customization:
            VehicleCustomization.fromJson(j['customization'] as Map<String, dynamic>),
        unlockedAt: DateTime.parse(j['unlockedAt'] as String),
      );
}
