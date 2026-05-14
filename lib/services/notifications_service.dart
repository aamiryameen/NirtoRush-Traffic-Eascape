import '../config/feature_flags.dart';

/// Push & local notifications facade. Stubbed until FCM is wired.
class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();

  Future<void> init() async {
    if (!FeatureFlags.pushNotificationsEnabled) return;
    // Future: register FCM, request POST_NOTIFICATIONS, schedule fuel-restored local notifs.
  }

  Future<void> scheduleFuelRestored(Duration when) async {}
  Future<void> cancelAll() async {}
}
