import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/run_result.dart';
import '../../../data/seed/vehicle_catalog.dart';
import '../../../game/nitro_game.dart';
import '../../../services/analytics_service.dart';
import '../../../services/haptics_service.dart';
import '../../../state/economy_provider.dart';
import '../../../state/garage_provider.dart';
import '../../../data/models/enums.dart';
import '../../../state/missions_provider.dart';
import '../../../state/player_provider.dart';
import '../../../state/run_provider.dart';
import '../../../state/settings_provider.dart';
import '../results/results_screen.dart';
import 'widgets/gameplay_hud.dart';
import 'widgets/pause_overlay.dart';
import 'widgets/touch_controls.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({super.key});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  late NitroGame _game;
  final ValueNotifier<GameStateSnapshot?> _snapshot = ValueNotifier(null);
  bool _paused = false;
  bool _ended = false;

  @override
  void dispose() {
    _snapshot.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _build();
  }

  void _build() {
    final garage = ref.read(garageProvider);
    final mode = ref.read(selectedModeProvider);
    final settings = ref.read(settingsProvider);
    final vehicle = VehicleCatalog.byId(garage.selectedVehicleId);
    final owned = garage.selected;

    _game = NitroGame(
      mode: mode,
      mapId: garage.selectedMapId,
      vehicleId: vehicle.id,
      customization: owned.customization,
      upgrades: owned.upgrades,
      settings: settings,
    )
      ..onStateChange = (s) {
        _snapshot.value = s;
      }
      ..onGameOver = _handleGameOver;

    AnalyticsService.instance.runStart(mode.name, garage.selectedMapId, vehicle.id);
  }

  Future<void> _handleGameOver(RunResult r) async {
    if (_ended) return;
    _ended = true;
    HapticsService.instance.crash();
    ref.read(runResultProvider.notifier).set(r);

    // Award coins + xp
    await ref.read(economyProvider.notifier).add(CurrencyType.coins, r.coinsEarned);
    await ref.read(playerProvider.notifier).addXp(r.xpEarned);

    // Mission progress
    final missions = ref.read(missionsProvider.notifier);
    await missions.reportProgress('distance_m', r.distance.round());
    await missions.reportProgress('overtake_count', r.overtakes);
    await missions.reportProgress('runs_completed', 1);
    await missions.reportProgress('coins_earned', r.coinsEarned);
    await missions.reportProgress('police_escaped', r.policeEscaped);
    await missions.reportMax('top_speed_kmh', (r.topSpeed * 0.625).round());

    AnalyticsService.instance.runEnd(r.mode.name, r.distance, r.score);

    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ResultsScreen()),
    );
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _game.pauseEngine();
    } else {
      _game.resumeEngine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDarkest,
      body: Stack(
        children: [
          GameWidget<NitroGame>(game: _game),
          ValueListenableBuilder<GameStateSnapshot?>(
            valueListenable: _snapshot,
            builder: (context, snap, _) {
              if (snap == null) return const SizedBox.shrink();
              return GameplayHUD(snapshot: snap, onPause: _togglePause);
            },
          ),
          TouchControls(
            onSteer: (v) {
              // v == 0 is a release signal; any other value is a finger
              // delta that accumulates until the next game frame consumes it.
              if (v == 0) {
                _game.input.steerDelta = 0;
              } else {
                _game.input.steerDelta += v;
              }
            },
            onBrake: (v) => _game.input.brake = v,
            onNitro: (v) => _game.input.nitro = v,
          ),
          if (_paused)
            PauseOverlay(
              onResume: _togglePause,
              onRestart: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GameplayScreen()),
                );
              },
              onQuit: () => Navigator.of(context).pop(),
            ),
        ],
      ),
    );
  }
}
