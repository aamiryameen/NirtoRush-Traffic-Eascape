import '../config/feature_flags.dart';
import '../core/utils/logger.dart';

/// Analytics facade. When Firebase is disabled, events are logged to console
/// so you can see the funnel during local development.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  static const _tag = 'Analytics';

  Future<void> init() async {
    if (!FeatureFlags.firebaseEnabled) return;
    // await Firebase.initializeApp(); etc.
  }

  void event(String name, [Map<String, Object?>? params]) {
    if (!FeatureFlags.firebaseEnabled) {
      Log.d(_tag, '$name ${params ?? const {}}');
      return;
    }
    // FirebaseAnalytics.instance.logEvent(...);
  }

  void runStart(String mode, String mapId, String vehicleId) =>
      event('run_start', {'mode': mode, 'map': mapId, 'vehicle': vehicleId});

  void runEnd(String mode, double distance, int score) =>
      event('run_end', {'mode': mode, 'distance': distance, 'score': score});

  void purchase(String sku, double price, String currency) =>
      event('purchase', {'sku': sku, 'price': price, 'currency': currency});

  void adView(String type) => event('ad_view', {'type': type});
}
