import '../models/battle_pass.dart';

class BattlePassSeed {
  BattlePassSeed._();

  /// Reward layout for the current season (paired tiers: free + premium).
  static const List<(BattlePassReward free, BattlePassReward premium)> tiers = [
    (
      BattlePassReward(tier: 1, name: '+200 Coins', coins: 200),
      BattlePassReward(tier: 1, name: '+25 Gems', gems: 25, premium: true),
    ),
    (
      BattlePassReward(tier: 2, name: '+300 Coins', coins: 300),
      BattlePassReward(tier: 2, name: 'Neon Trail FX', premium: true),
    ),
    (
      BattlePassReward(tier: 3, name: '+400 Coins', coins: 400),
      BattlePassReward(tier: 3, name: '+50 Gems', gems: 50, premium: true),
    ),
    (
      BattlePassReward(tier: 4, name: '+500 Coins', coins: 500),
      BattlePassReward(
          tier: 4, name: 'Phantom GT-R', vehicleId: 'sports_gtr', premium: true),
    ),
    (
      BattlePassReward(tier: 5, name: '+700 Coins', coins: 700),
      BattlePassReward(tier: 5, name: '+100 Gems', gems: 100, premium: true),
    ),
    (
      BattlePassReward(tier: 10, name: '+1500 Coins', coins: 1500),
      BattlePassReward(
          tier: 10, name: 'Vyper Zero', vehicleId: 'hyper_bugatti', premium: true),
    ),
    (
      BattlePassReward(tier: 25, name: '+3000 Coins', coins: 3000),
      BattlePassReward(tier: 25, name: 'Exclusive Vinyl', premium: true),
    ),
    (
      BattlePassReward(tier: 50, name: '+5000 Coins', coins: 5000),
      BattlePassReward(
          tier: 50, name: 'Neon X1 (Mythic)', vehicleId: 'hyper_neonx', premium: true),
    ),
  ];

  static BattlePassState defaultSeason() {
    final now = DateTime.now();
    return BattlePassState(
      seasonId: 's1_${now.year}_${now.month}',
      seasonName: 'Season 1: Neon Nights',
      startsAt: DateTime(now.year, now.month, 1),
      endsAt: DateTime(now.year, now.month + 1, 1),
    );
  }
}
