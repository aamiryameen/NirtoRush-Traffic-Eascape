import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/player_profile.dart';
import '../services/auth_service.dart';
import '../services/local_storage.dart';

class PlayerNotifier extends StateNotifier<PlayerProfile?> {
  PlayerNotifier() : super(null);

  Future<void> load() async {
    final raw = LocalStorage.instance.readPlayer();
    if (raw != null) {
      state = PlayerProfile.fromJson(raw);
    } else {
      final guest = AuthService.instance.createGuestProfile();
      state = guest;
      await LocalStorage.instance.writePlayer(guest.toJson());
    }
  }

  Future<void> addXp(int xp) async {
    final p = state;
    if (p == null) return;
    final newXp = p.xp + xp;
    final newLevel = PlayerProfile.levelFromXp(newXp);
    state = p.copyWith(xp: newXp, level: newLevel);
    await LocalStorage.instance.writePlayer(state!.toJson());
  }

  Future<void> setUsername(String name) async {
    state = state?.copyWith(username: name);
    if (state != null) await LocalStorage.instance.writePlayer(state!.toJson());
  }

  Future<void> recordDailyClaim() async {
    final p = state;
    if (p == null) return;
    final now = DateTime.now();
    final last = p.lastDailyClaim;
    final streak = (last != null && now.difference(last).inHours < 48)
        ? p.dailyLoginStreak + 1
        : 1;
    state = p.copyWith(dailyLoginStreak: streak, lastDailyClaim: now);
    await LocalStorage.instance.writePlayer(state!.toJson());
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerProfile?>((ref) => PlayerNotifier());
