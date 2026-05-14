class BattlePassReward {
  final int tier;
  final String name;
  final String? vehicleId;
  final int coins;
  final int gems;
  final bool premium;

  const BattlePassReward({
    required this.tier,
    required this.name,
    this.vehicleId,
    this.coins = 0,
    this.gems = 0,
    this.premium = false,
  });
}

class BattlePassState {
  final String seasonId;
  final String seasonName;
  final int xp;
  final int tier;
  final bool premiumUnlocked;
  final Set<int> claimedFreeTiers;
  final Set<int> claimedPremiumTiers;
  final DateTime startsAt;
  final DateTime endsAt;

  const BattlePassState({
    required this.seasonId,
    required this.seasonName,
    this.xp = 0,
    this.tier = 1,
    this.premiumUnlocked = false,
    this.claimedFreeTiers = const {},
    this.claimedPremiumTiers = const {},
    required this.startsAt,
    required this.endsAt,
  });

  static const int xpPerTier = 1000;
  static const int maxTier = 50;

  BattlePassState copyWith({
    int? xp,
    int? tier,
    bool? premiumUnlocked,
    Set<int>? claimedFreeTiers,
    Set<int>? claimedPremiumTiers,
  }) =>
      BattlePassState(
        seasonId: seasonId,
        seasonName: seasonName,
        xp: xp ?? this.xp,
        tier: tier ?? this.tier,
        premiumUnlocked: premiumUnlocked ?? this.premiumUnlocked,
        claimedFreeTiers: claimedFreeTiers ?? this.claimedFreeTiers,
        claimedPremiumTiers: claimedPremiumTiers ?? this.claimedPremiumTiers,
        startsAt: startsAt,
        endsAt: endsAt,
      );

  Map<String, dynamic> toJson() => {
        'seasonId': seasonId,
        'seasonName': seasonName,
        'xp': xp,
        'tier': tier,
        'premiumUnlocked': premiumUnlocked,
        'claimedFreeTiers': claimedFreeTiers.toList(),
        'claimedPremiumTiers': claimedPremiumTiers.toList(),
        'startsAt': startsAt.toIso8601String(),
        'endsAt': endsAt.toIso8601String(),
      };

  factory BattlePassState.fromJson(Map<String, dynamic> j) => BattlePassState(
        seasonId: j['seasonId'] as String,
        seasonName: j['seasonName'] as String,
        xp: j['xp'] as int? ?? 0,
        tier: j['tier'] as int? ?? 1,
        premiumUnlocked: j['premiumUnlocked'] as bool? ?? false,
        claimedFreeTiers:
            ((j['claimedFreeTiers'] as List?)?.cast<int>().toSet()) ?? <int>{},
        claimedPremiumTiers:
            ((j['claimedPremiumTiers'] as List?)?.cast<int>().toSet()) ?? <int>{},
        startsAt: DateTime.parse(j['startsAt'] as String),
        endsAt: DateTime.parse(j['endsAt'] as String),
      );
}
