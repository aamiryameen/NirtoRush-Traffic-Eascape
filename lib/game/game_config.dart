/// Game-internal tuning constants. Kept separate from user-facing
/// AppConstants so balance tweaks don't churn UI strings.
class GameConfig {
  GameConfig._();

  // Road geometry (world units = pixels)
  static const double laneCount = 4;
  static const double laneWidth = 110.0;
  static const double roadShoulder = 30.0;
  static double get roadWidth => laneWidth * laneCount + roadShoulder * 2;

  // Player tuning
  static const double playerCarWidth = 70.0;
  static const double playerCarHeight = 120.0;
  static const double playerYFraction = 0.78; // % from top of screen
  // Lateral movement now follows the finger 1:1 (see GameInput.steerDelta),
  // so there is no fixed lateral speed constant.

  // Speed
  static const double baseForwardSpeed = 320.0;
  static const double accelerationPerSec = 12.0;
  static const double maxForwardSpeed = 720.0;
  static const double nitroBoost = 1.65;

  // Nitro tank (seconds)
  static const double nitroMaxSeconds = 4.0;
  static const double nitroRegenPerSec = 0.4;

  // Traffic
  static const double trafficSpawnIntervalMin = 0.6;
  static const double trafficSpawnIntervalMax = 1.4;
  static const double trafficCarWidth = 70.0;
  static const double trafficCarHeight = 120.0;
  static const double trafficBaseSpeed = 140.0;

  // Coins (pickups)
  static const double coinSpawnInterval = 1.8;

  // Police
  static const double policeSpawnTriggerDistance = 1500.0;
  static const int policeMaxConcurrent = 4;

  // Scoring
  static const int overtakeScore = 25;
  static const int coinPickupValue = 5;
}
