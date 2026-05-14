import 'dart:async';
import '../config/feature_flags.dart';
import '../core/utils/logger.dart';
import '../data/models/enums.dart';

/// AdMob facade. When [FeatureFlags.admobEnabled] is false, all methods
/// are no-ops that return success — keeps gameplay paths simple.
///
/// To enable real ads:
///  1. Uncomment google_mobile_ads in pubspec.yaml.
///  2. Fill in Secrets with real unit IDs.
///  3. Uncomment the MobileAds.instance.initialize() in init().
///  4. Replace the simulated load/show with the real API.
class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  static const _tag = 'AdsService';

  Future<void> init() async {
    if (!FeatureFlags.admobEnabled) {
      Log.i(_tag, 'AdMob disabled — running in offline mode');
      return;
    }
    // await MobileAds.instance.initialize();
  }

  Future<bool> showRewarded(AdType type) async {
    if (!FeatureFlags.admobEnabled) {
      // Treat as success so reward flow stays testable offline.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return true;
    }
    return false;
  }

  Future<void> showInterstitial() async {
    if (!FeatureFlags.admobEnabled) return;
  }

  Future<void> showAppOpen() async {
    if (!FeatureFlags.admobEnabled) return;
  }
}
