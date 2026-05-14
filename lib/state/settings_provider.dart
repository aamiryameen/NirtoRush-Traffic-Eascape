import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/settings_data.dart';
import '../services/audio_service.dart';
import '../services/haptics_service.dart';
import '../services/local_storage.dart';

class SettingsNotifier extends StateNotifier<SettingsData> {
  SettingsNotifier() : super(const SettingsData());

  Future<void> load() async {
    final raw = LocalStorage.instance.readSettings();
    if (raw != null) {
      state = SettingsData.fromJson(raw);
    }
    _apply();
  }

  Future<void> update(SettingsData next) async {
    state = next;
    await LocalStorage.instance.writeSettings(next.toJson());
    _apply();
  }

  void _apply() {
    AudioService.instance.setMusicVolume(state.musicVolume);
    AudioService.instance.setSfxVolume(state.sfxVolume);
    HapticsService.instance.enabled = state.vibrationEnabled;
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsData>((ref) => SettingsNotifier());
