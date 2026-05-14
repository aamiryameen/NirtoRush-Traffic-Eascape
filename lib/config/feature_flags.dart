/// Runtime feature flags. Toggle systems on/off without code churn.
class FeatureFlags {
  FeatureFlags._();

  // Backend & monetization (disabled by default until credentials configured)
  static const bool supabaseEnabled = false;
  static const bool admobEnabled = false;
  static const bool firebaseEnabled = false;
  static const bool pushNotificationsEnabled = false;

  // Gameplay systems
  static const bool policeChaseEnabled = true;
  static const bool weatherEnabled = true;
  static const bool dayNightCycleEnabled = true;
  static const bool tiltSteeringEnabled = true;
  static const bool screenShakeEnabled = true;
  static const bool motionBlurEnabled = true;

  // Live ops
  static const bool battlePassEnabled = true;
  static const bool liveEventsEnabled = true;
  static const bool multiplayerGhostEnabled = false; // stubbed

  // Debug
  static const bool showFps = false;
  static const bool showHitboxes = false;
  static const bool godMode = false;
}
