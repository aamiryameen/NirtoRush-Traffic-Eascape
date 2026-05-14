class AppConstants {
  AppConstants._();

  static const String appName = 'NitroRush: Traffic Escape';
  static const String appShortName = 'NitroRush';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@nitrorush.app';

  // Hive box names
  static const String hivePlayerBox = 'player_box';
  static const String hiveSettingsBox = 'settings_box';
  static const String hiveMissionsBox = 'missions_box';
  static const String hiveGarageBox = 'garage_box';
  static const String hiveEconomyBox = 'economy_box';
  static const String hiveBattlePassBox = 'battle_pass_box';
  static const String hiveEventsBox = 'events_box';

  // Default economy values
  static const int startingCoins = 500;
  static const int startingGems = 25;
  static const int maxFuel = 30;
  static const int fuelRegenSeconds = 180; // 1 fuel / 3 min

  // Daily login streak rewards (coins)
  static const List<int> dailyRewardCoins = [100, 200, 300, 500, 750, 1000, 2000];

  // Game tuning
  static const double baseRoadSpeed = 320.0;
  static const double maxRoadSpeed = 720.0;
  static const double nitroMultiplier = 1.65;
  static const double policeSpawnDistance = 2500.0;

  // Wanted level thresholds (meters driven while triggering)
  static const List<int> wantedLevelThresholds = [0, 600, 1500, 3000, 5500, 9000];
}
