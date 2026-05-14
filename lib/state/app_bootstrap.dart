import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ads_service.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/local_storage.dart';
import '../services/notifications_service.dart';
import '../services/supabase_service.dart';
import 'battle_pass_provider.dart';
import 'economy_provider.dart';
import 'garage_provider.dart';
import 'missions_provider.dart';
import 'player_provider.dart';
import 'settings_provider.dart';

/// One-shot startup: init services then hydrate Riverpod state from disk.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  await LocalStorage.instance.init();
  await AudioService.instance.init();
  await AdsService.instance.init();
  await AnalyticsService.instance.init();
  await SupabaseService.instance.init();
  await NotificationsService.instance.init();

  await ref.read(settingsProvider.notifier).load();
  await ref.read(playerProvider.notifier).load();
  await ref.read(economyProvider.notifier).load();
  await ref.read(garageProvider.notifier).load();
  await ref.read(missionsProvider.notifier).load();
  await ref.read(battlePassProvider.notifier).load();
});
