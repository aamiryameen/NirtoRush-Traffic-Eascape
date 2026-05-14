import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

/// Thin Hive-backed JSON store. We persist Map/JSON blobs (not generated
/// type adapters) so the schema can evolve without code-gen churn.
class LocalStorage {
  LocalStorage._();
  static final LocalStorage instance = LocalStorage._();

  static const _tag = 'LocalStorage';

  Box<String>? _player;
  Box<String>? _settings;
  Box<String>? _missions;
  Box<String>? _garage;
  Box<String>? _economy;
  Box<String>? _battlePass;
  Box<String>? _events;

  Future<void> init() async {
    await Hive.initFlutter();
    _player = await Hive.openBox<String>(AppConstants.hivePlayerBox);
    _settings = await Hive.openBox<String>(AppConstants.hiveSettingsBox);
    _missions = await Hive.openBox<String>(AppConstants.hiveMissionsBox);
    _garage = await Hive.openBox<String>(AppConstants.hiveGarageBox);
    _economy = await Hive.openBox<String>(AppConstants.hiveEconomyBox);
    _battlePass = await Hive.openBox<String>(AppConstants.hiveBattlePassBox);
    _events = await Hive.openBox<String>(AppConstants.hiveEventsBox);
    Log.i(_tag, 'Hive initialized');
  }

  // ===== Player =====
  Map<String, dynamic>? readPlayer() => _decode(_player?.get('profile'));
  Future<void> writePlayer(Map<String, dynamic> data) async =>
      _player?.put('profile', jsonEncode(data));

  // ===== Settings =====
  Map<String, dynamic>? readSettings() => _decode(_settings?.get('settings'));
  Future<void> writeSettings(Map<String, dynamic> data) async =>
      _settings?.put('settings', jsonEncode(data));

  // ===== Economy =====
  Map<String, dynamic>? readWallet() => _decode(_economy?.get('wallet'));
  Future<void> writeWallet(Map<String, dynamic> data) async =>
      _economy?.put('wallet', jsonEncode(data));

  // ===== Garage =====
  List<Map<String, dynamic>> readOwnedVehicles() {
    final raw = _garage?.get('owned');
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> writeOwnedVehicles(List<Map<String, dynamic>> list) async =>
      _garage?.put('owned', jsonEncode(list));

  String? readSelectedVehicleId() => _garage?.get('selected');
  Future<void> writeSelectedVehicleId(String id) async =>
      _garage?.put('selected', id);

  String? readSelectedMapId() => _garage?.get('selectedMap');
  Future<void> writeSelectedMapId(String id) async =>
      _garage?.put('selectedMap', id);

  // ===== Missions =====
  List<Map<String, dynamic>> readMissions() {
    final raw = _missions?.get('missions');
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> writeMissions(List<Map<String, dynamic>> list) async =>
      _missions?.put('missions', jsonEncode(list));

  // ===== Stats / progression =====
  double readLifetimeDistance() =>
      double.tryParse(_player?.get('lifetimeDistance') ?? '0') ?? 0;

  Future<void> writeLifetimeDistance(double v) async =>
      _player?.put('lifetimeDistance', v.toString());

  int readHighScore() => int.tryParse(_player?.get('highScore') ?? '0') ?? 0;
  Future<void> writeHighScore(int v) async =>
      _player?.put('highScore', v.toString());

  double readTopSpeedKmh() =>
      double.tryParse(_player?.get('topSpeedKmh') ?? '0') ?? 0;
  Future<void> writeTopSpeedKmh(double v) async =>
      _player?.put('topSpeedKmh', v.toString());

  int readTotalRuns() => int.tryParse(_player?.get('totalRuns') ?? '0') ?? 0;
  Future<void> writeTotalRuns(int v) async =>
      _player?.put('totalRuns', v.toString());

  // ===== Battle pass =====
  Map<String, dynamic>? readBattlePass() => _decode(_battlePass?.get('state'));
  Future<void> writeBattlePass(Map<String, dynamic> data) async =>
      _battlePass?.put('state', jsonEncode(data));

  // ===== Events =====
  Map<String, int> readEventProgress() {
    final raw = _events?.get('progress');
    if (raw == null) return {};
    return (jsonDecode(raw) as Map).cast<String, int>();
  }

  Future<void> writeEventProgress(Map<String, int> map) async =>
      _events?.put('progress', jsonEncode(map));

  // ===== util =====
  Map<String, dynamic>? _decode(String? raw) =>
      raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;

  Future<void> wipe() async {
    await _player?.clear();
    await _settings?.clear();
    await _missions?.clear();
    await _garage?.clear();
    await _economy?.clear();
    await _battlePass?.clear();
    await _events?.clear();
  }
}
