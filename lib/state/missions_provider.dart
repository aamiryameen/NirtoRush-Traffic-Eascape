import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/enums.dart';
import '../data/models/mission.dart';
import '../data/seed/mission_templates.dart';
import '../services/local_storage.dart';
import 'economy_provider.dart';
import 'player_provider.dart';

class MissionsNotifier extends StateNotifier<List<Mission>> {
  MissionsNotifier(this.ref) : super(const []);

  final Ref ref;

  Future<void> load() async {
    final raw = LocalStorage.instance.readMissions();
    final now = DateTime.now();
    final loaded = raw.map(Mission.fromJson).toList();
    final active = loaded.where((m) => m.expiresAt.isAfter(now)).toList();

    if (!active.any((m) => m.type == MissionType.daily)) {
      active.addAll(MissionTemplates.generateDaily(now));
    }
    if (!active.any((m) => m.type == MissionType.weekly)) {
      active.addAll(MissionTemplates.generateWeekly(now));
    }
    state = active;
    await _persist();
  }

  Future<void> _persist() => LocalStorage.instance
      .writeMissions(state.map((m) => m.toJson()).toList());

  Future<void> reportProgress(String metric, int delta) async {
    final updated = state.map((m) {
      if (m.metric != metric || m.status != MissionStatus.active) return m;
      final next = m.progress + delta;
      final newStatus = next >= m.target ? MissionStatus.completed : m.status;
      return m.copyWith(progress: next.clamp(0, m.target), status: newStatus);
    }).toList();
    state = updated;
    await _persist();
  }

  /// Report a "max" metric (e.g. top speed): keep the highest value seen.
  Future<void> reportMax(String metric, int value) async {
    final updated = state.map((m) {
      if (m.metric != metric || m.status != MissionStatus.active) return m;
      if (value <= m.progress) return m;
      final newStatus = value >= m.target ? MissionStatus.completed : m.status;
      return m.copyWith(progress: value.clamp(0, m.target), status: newStatus);
    }).toList();
    state = updated;
    await _persist();
  }

  Future<bool> claim(String missionId) async {
    final mission = state.firstWhere((m) => m.id == missionId);
    if (mission.status != MissionStatus.completed) return false;
    final econ = ref.read(economyProvider.notifier);
    final player = ref.read(playerProvider.notifier);
    if (mission.rewardCoins > 0) await econ.add(CurrencyType.coins, mission.rewardCoins);
    if (mission.rewardGems > 0) await econ.add(CurrencyType.gems, mission.rewardGems);
    if (mission.rewardXp > 0) await player.addXp(mission.rewardXp);
    state = state
        .map((m) => m.id == missionId ? m.copyWith(status: MissionStatus.claimed) : m)
        .toList();
    await _persist();
    return true;
  }
}

final missionsProvider =
    StateNotifierProvider<MissionsNotifier, List<Mission>>((ref) => MissionsNotifier(ref));
