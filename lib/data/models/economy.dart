import 'enums.dart';

class Wallet {
  final int coins;
  final int gems;
  final int fuel;
  final int eventTokens;
  final DateTime lastFuelTickAt;

  const Wallet({
    this.coins = 0,
    this.gems = 0,
    this.fuel = 30,
    this.eventTokens = 0,
    required this.lastFuelTickAt,
  });

  int amount(CurrencyType type) => switch (type) {
        CurrencyType.coins => coins,
        CurrencyType.gems => gems,
        CurrencyType.fuel => fuel,
        CurrencyType.eventTokens => eventTokens,
      };

  Wallet copyWith({
    int? coins,
    int? gems,
    int? fuel,
    int? eventTokens,
    DateTime? lastFuelTickAt,
  }) =>
      Wallet(
        coins: coins ?? this.coins,
        gems: gems ?? this.gems,
        fuel: fuel ?? this.fuel,
        eventTokens: eventTokens ?? this.eventTokens,
        lastFuelTickAt: lastFuelTickAt ?? this.lastFuelTickAt,
      );

  Wallet add(CurrencyType t, int amount) => switch (t) {
        CurrencyType.coins => copyWith(coins: coins + amount),
        CurrencyType.gems => copyWith(gems: gems + amount),
        CurrencyType.fuel => copyWith(fuel: fuel + amount),
        CurrencyType.eventTokens => copyWith(eventTokens: eventTokens + amount),
      };

  Map<String, dynamic> toJson() => {
        'coins': coins,
        'gems': gems,
        'fuel': fuel,
        'eventTokens': eventTokens,
        'lastFuelTickAt': lastFuelTickAt.toIso8601String(),
      };

  factory Wallet.fromJson(Map<String, dynamic> j) => Wallet(
        coins: j['coins'] as int? ?? 0,
        gems: j['gems'] as int? ?? 0,
        fuel: j['fuel'] as int? ?? 30,
        eventTokens: j['eventTokens'] as int? ?? 0,
        lastFuelTickAt: j['lastFuelTickAt'] != null
            ? DateTime.parse(j['lastFuelTickAt'] as String)
            : DateTime.now(),
      );
}
