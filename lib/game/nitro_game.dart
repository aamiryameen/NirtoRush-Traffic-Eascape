import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../data/models/enums.dart';
import '../data/models/map_definition.dart';
import '../data/models/run_result.dart';
import '../data/models/settings_data.dart';
import '../data/models/vehicle.dart';
import '../data/seed/map_catalog.dart';
import '../data/seed/vehicle_catalog.dart';
import 'components/effects/coin_pickup.dart';
import 'components/effects/particle_burst.dart';
import 'components/effects/speed_lines.dart';
import 'components/vehicles/player_car.dart';
import 'components/vehicles/police_car.dart';
import 'components/vehicles/traffic_car.dart';
import 'game_config.dart';
import 'world/road_renderer.dart';
import 'world/sky_renderer.dart';

/// Input directives applied each frame by the UI layer.
class GameInput {
  /// Pending horizontal finger movement in screen pixels, accumulated since
  /// the last game frame. The game applies it directly to the car (so the car
  /// follows the finger 1:1) and then resets it to 0 — it is a delta, not a
  /// velocity, so the car stops the instant the finger stops.
  double steerDelta = 0;
  bool brake = false;
  bool nitro = false;
}

/// External (HUD/UI) view of the game's live state.
class GameStateSnapshot {
  final double speedKmh;
  final double distance;
  final int coins;
  final int score;
  final int overtakes;
  final double nitroSeconds;
  final int wantedLevel;
  final bool isGameOver;

  const GameStateSnapshot({
    required this.speedKmh,
    required this.distance,
    required this.coins,
    required this.score,
    required this.overtakes,
    required this.nitroSeconds,
    required this.wantedLevel,
    required this.isGameOver,
  });
}

class NitroGame extends FlameGame with HasCollisionDetection {
  NitroGame({
    required this.mode,
    required this.mapId,
    required this.vehicleId,
    required this.customization,
    required this.upgrades,
    required this.settings,
  });

  final GameMode mode;
  final String mapId;
  final String vehicleId;
  final VehicleCustomization customization;
  final VehicleUpgrades upgrades;
  final SettingsData settings;

  // External input (wired by the gameplay screen)
  final GameInput input = GameInput();

  // External callbacks
  void Function(RunResult)? onGameOver;
  void Function(GameStateSnapshot)? onStateChange;

  // World
  late RoadRenderer road;
  late SkyRenderer sky;
  late PlayerCar player;
  late SpeedLines speedLines;
  bool _ready = false;

  // State
  double _forwardSpeed = GameConfig.baseForwardSpeed;
  double _distance = 0;
  int _coins = 0;
  int _overtakes = 0;
  int _score = 0;
  double _nitro = GameConfig.nitroMaxSeconds;
  bool _gameOver = false;
  double _topSpeed = 0;
  double _runStartedAt = 0;
  int _wantedLevel = 0;
  int _policeEscapedCount = 0;
  int _wantedLevelMax = 0;

  // Spawning
  final Random _rng = Random();
  double _trafficTimer = 0;
  double _coinTimer = 0;
  double _policeTimer = 0;

  // Getters
  double get forwardSpeed => _forwardSpeed;
  double get speedKmh => _forwardSpeed * 0.625;
  double get distance => _distance;
  int get coinsCollected => _coins;
  int get score => _score;
  int get overtakes => _overtakes;
  double get nitroSeconds => _nitro;
  int get wantedLevel => _wantedLevel;
  bool get isGameOver => _gameOver;

  // Map + vehicle defs
  late final MapDefinition _map;
  late final Vehicle _vehicleDef;

  @override
  Color backgroundColor() => const Color(0xFF050610);

  @override
  Future<void> onLoad() async {
    _map = MapCatalog.byId(mapId);
    _vehicleDef = VehicleCatalog.byId(vehicleId);
    _runStartedAt = DateTime.now().millisecondsSinceEpoch.toDouble();

    // Sky / road
    sky = SkyRenderer(topColor: _map.skyTop, bottomColor: _map.skyBottom)
      ..size = size
      ..position = Vector2.zero();
    add(sky);

    road = RoadRenderer(roadColor: _map.roadColor, groundColor: _map.groundColor)
      ..size = size
      ..position = Vector2.zero();
    add(road);

    // Player
    player = PlayerCar(
      bodyColor: Color(customization.paintColor),
      accentColor: _vehicleDef.secondaryColor,
      neonColor: customization.neonColor != 0 ? Color(customization.neonColor) : null,
      exhaustFlames: customization.exhaustFlames,
      onCollide: _crash,
    );
    player.position = Vector2(
      road.laneCenterX(GameConfig.laneCount ~/ 2 - 1),
      size.y * GameConfig.playerYFraction,
    );
    add(player);

    // Speed lines overlay
    speedLines = SpeedLines(bounds: size);
    add(speedLines);

    _ready = true;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!_ready) return;
    sky.size = size;
    road.size = size;
    speedLines.bounds = size;
    player.position.x = player.position.x
        .clamp(road.roadLeft + player.size.x / 2, road.roadRight - player.size.x / 2);
    player.position.y = size.y * GameConfig.playerYFraction;
  }

  // ===== main update loop =====
  @override
  void update(double dt) {
    super.update(dt);
    if (!_ready || _gameOver) return;

    _updateSpeed(dt);
    _updatePlayerLateral(dt);
    _updateScrolling(dt);
    _updateSpawning(dt);
    _updateTraffic(dt);
    _updatePolice(dt);
    _updateCoins(dt);
    _updateWanted(dt);
    _updateScoring(dt);
    _updateNitro(dt);
    _emitState();
  }

  void _updateSpeed(double dt) {
    final upgraded = upgrades.applyTo(_vehicleDef.baseStats);
    final maxSpeed = GameConfig.baseForwardSpeed +
        (GameConfig.maxForwardSpeed - GameConfig.baseForwardSpeed) *
            (upgraded.speed / 100);

    final accel = GameConfig.accelerationPerSec * (1 + upgraded.acceleration / 100);

    if (input.brake) {
      _forwardSpeed -= 240 * dt;
    } else if (input.nitro && _nitro > 0) {
      _forwardSpeed += accel * 4 * dt;
    } else {
      _forwardSpeed += accel * dt;
    }
    final cap = input.nitro && _nitro > 0
        ? maxSpeed * GameConfig.nitroBoost
        : maxSpeed;
    _forwardSpeed = _forwardSpeed.clamp(GameConfig.baseForwardSpeed * 0.7, cap);
    if (_forwardSpeed > _topSpeed) _topSpeed = _forwardSpeed;
  }

  void _updatePlayerLateral(double dt) {
    final handling = upgrades.applyTo(_vehicleDef.baseStats).handling;
    // The car follows the finger 1:1. Handling adds a small responsiveness
    // multiplier (0.9x for a low-handling car, up to ~1.4x fully upgraded).
    final responsiveness = 0.9 + handling / 250;
    final dx = input.steerDelta * responsiveness;
    player.position.x = (player.position.x + dx)
        .clamp(road.roadLeft + player.size.x / 2, road.roadRight - player.size.x / 2);

    // Visual lean reflects the speed of finger movement this frame.
    final steerIntent = (dx / 12).clamp(-1.0, 1.0);
    player.tilt += (steerIntent - player.tilt) * dt * 12;

    // Delta consumed — reset so the car stops when the finger stops.
    input.steerDelta = 0;
  }

  void _updateScrolling(double dt) {
    road.scrollOffset += _forwardSpeed * dt;
    _distance += _forwardSpeed * dt * 0.1; // m (tuned for nice readouts)

    speedLines.opacity = input.nitro && _nitro > 0
        ? (speedLines.opacity + dt * 4).clamp(0.0, 1.0)
        : (speedLines.opacity - dt * 4).clamp(0.0, 1.0);
  }

  void _updateSpawning(double dt) {
    _trafficTimer -= dt;
    _coinTimer -= dt;
    _policeTimer -= dt;

    if (_trafficTimer <= 0) {
      _spawnTraffic();
      final density = _trafficDensity();
      _trafficTimer = GameConfig.trafficSpawnIntervalMin +
          _rng.nextDouble() *
              (GameConfig.trafficSpawnIntervalMax - GameConfig.trafficSpawnIntervalMin) /
              density;
    }

    if (_coinTimer <= 0) {
      _spawnCoinLine();
      _coinTimer = GameConfig.coinSpawnInterval + _rng.nextDouble() * 1.5;
    }

    // Police spawn after threshold distance or when wanted > 0
    final shouldSpawnPolice = (_distance > GameConfig.policeSpawnTriggerDistance ||
            _wantedLevel > 0 ||
            mode == GameMode.policeEscape) &&
        _policeTimer <= 0;
    if (shouldSpawnPolice && _policeCount() < GameConfig.policeMaxConcurrent + _wantedLevel) {
      _spawnPolice();
      _policeTimer = (4 - _wantedLevel * 0.5).clamp(1.5, 6.0);
    }
  }

  double _trafficDensity() {
    // Higher speed → spawn more aggressively, scales with distance
    final speedFactor = (_forwardSpeed / GameConfig.maxForwardSpeed).clamp(0.5, 1.4);
    final distFactor = 1 + (_distance / 8000).clamp(0.0, 1.0);
    return speedFactor * distFactor;
  }

  int _policeCount() => children.whereType<PoliceCar>().length;

  void _spawnTraffic() {
    final lane = _rng.nextInt(GameConfig.laneCount.toInt());
    final kind = TrafficCar.weightedRandom(_rng);
    final color = _trafficColorFor(kind);
    final spd = TrafficCar.speedForKind(kind, _rng);
    final car = TrafficCar(kind: kind, speed: spd, lane: lane, bodyColor: color);
    final spawnY = -car.size.y;
    car.position = Vector2(road.laneCenterX(lane), spawnY);
    add(car);
  }

  Color _trafficColorFor(TrafficKind k) {
    const palette = [
      Color(0xFFB71C1C), Color(0xFF1565C0), Color(0xFF2E7D32),
      Color(0xFFF9A825), Color(0xFF6A1B9A), Color(0xFF263238),
      Color(0xFFE0E0E0), Color(0xFFFF7043),
    ];
    if (k == TrafficKind.bus) return const Color(0xFFFFC107);
    if (k == TrafficKind.truck) return const Color(0xFF455A64);
    return palette[_rng.nextInt(palette.length)];
  }

  void _spawnPolice() {
    final lane = _rng.nextInt(GameConfig.laneCount.toInt());
    final speed = _forwardSpeed * (0.85 + _rng.nextDouble() * 0.2);
    final police = PoliceCar(speed: speed, lane: lane);
    police.position = Vector2(road.laneCenterX(lane), -police.size.y - 60);
    add(police);
  }

  void _spawnCoinLine() {
    final lane = _rng.nextInt(GameConfig.laneCount.toInt());
    final count = 3 + _rng.nextInt(4);
    for (var i = 0; i < count; i++) {
      final c = CoinPickup();
      c.position = Vector2(road.laneCenterX(lane), -i * 60.0);
      add(c);
    }
  }

  // ===== traffic & police movement =====
  void _updateTraffic(double dt) {
    final toRemove = <TrafficCar>[];
    for (final t in children.whereType<TrafficCar>()) {
      // Traffic moves with the world (relative speed = player - traffic).
      t.position.y += (_forwardSpeed - t.speed) * dt;

      // Mark overtake the moment the traffic falls behind player center.
      if (!t.counted && t.position.y > player.position.y + 20) {
        t.counted = true;
        _overtakes++;
      }

      if (t.position.y > size.y + 200) toRemove.add(t);
    }
    for (final t in toRemove) {
      t.removeFromParent();
    }
  }

  void _updatePolice(double dt) {
    final toRemove = <PoliceCar>[];
    for (final p in children.whereType<PoliceCar>()) {
      // Police aggressively chases: closes distance based on horizontal gap to player.
      final targetX = player.position.x;
      p.position.x += ((targetX - p.position.x) * dt * 1.4).clamp(-180 * dt, 180 * dt);
      // Vertical: behind player, slowly catching up.
      final relSpeed = (_forwardSpeed - p.speed) * 0.6;
      p.position.y += relSpeed * dt;

      // Drift below screen → escape
      if (p.position.y > size.y + 300) {
        toRemove.add(p);
        _policeEscapedCount++;
      }
    }
    for (final p in toRemove) {
      p.removeFromParent();
    }
  }

  void _updateCoins(double dt) {
    final toRemove = <CoinPickup>[];
    for (final c in children.whereType<CoinPickup>()) {
      c.position.y += _forwardSpeed * dt;
      // Pickup detection: simple circle vs player center.
      if (!c.collected) {
        final dx = (c.position.x - player.position.x).abs();
        final dy = (c.position.y - player.position.y).abs();
        if (dx < 40 && dy < 50) {
          c.collected = true;
          _coins += GameConfig.coinPickupValue;
          add(ParticleBurst(
            origin: c.position.clone(),
            color: const Color(0xFFFFD740),
            count: 14,
            spread: 50,
            life: 0.4,
          ));
          toRemove.add(c);
        }
      }
      if (c.position.y > size.y + 50) toRemove.add(c);
    }
    for (final c in toRemove) {
      c.removeFromParent();
    }
  }

  void _updateWanted(double dt) {
    if (_distance > 400 && _wantedLevel == 0) {
      _wantedLevel = 1;
    }
    if (_distance > 1500 && _wantedLevel < 2) _wantedLevel = 2;
    if (_distance > 3000 && _wantedLevel < 3) _wantedLevel = 3;
    if (_distance > 5500 && _wantedLevel < 4) _wantedLevel = 4;
    if (_distance > 9000 && _wantedLevel < 5) _wantedLevel = 5;
    if (_wantedLevel > _wantedLevelMax) _wantedLevelMax = _wantedLevel;
  }

  void _updateScoring(double dt) {
    _score = _distance.round() + _overtakes * GameConfig.overtakeScore + _coins * 2;
  }

  void _updateNitro(double dt) {
    if (input.nitro) {
      _nitro = (_nitro - dt).clamp(0.0, GameConfig.nitroMaxSeconds);
    } else {
      _nitro = (_nitro + dt * GameConfig.nitroRegenPerSec)
          .clamp(0.0, GameConfig.nitroMaxSeconds);
    }
  }

  void _emitState() {
    onStateChange?.call(GameStateSnapshot(
      speedKmh: speedKmh,
      distance: _distance,
      coins: _coins,
      score: _score,
      overtakes: _overtakes,
      nitroSeconds: _nitro,
      wantedLevel: _wantedLevel,
      isGameOver: _gameOver,
    ));
  }

  // ===== collision =====
  void _crash() {
    if (_gameOver) return;
    _gameOver = true;

    // Burst + camera shake
    add(ParticleBurst(
      origin: player.position.clone(),
      color: const Color(0xFFFF6A00),
      count: 50,
      spread: 220,
      life: 0.8,
    ));
    add(ParticleBurst(
      origin: player.position.clone(),
      color: const Color(0xFFFFFFFF),
      count: 24,
      spread: 140,
      life: 0.5,
    ));
    camera.viewfinder.add(MoveEffect.by(
      Vector2(0, 14),
      EffectController(duration: 0.06, alternate: true, repeatCount: 5),
    ));

    final result = RunResult(
      mode: mode,
      mapId: mapId,
      vehicleId: vehicleId,
      distance: _distance,
      topSpeed: _topSpeed,
      overtakes: _overtakes,
      crashes: 1,
      coinsEarned: _coins,
      xpEarned: (_distance / 50).round() + _overtakes * 5,
      duration: Duration(
          milliseconds:
              (DateTime.now().millisecondsSinceEpoch - _runStartedAt).round()),
      driftScore: 0,
      policeEscaped: _policeEscapedCount,
      wantedLevelMax: _wantedLevelMax,
      startedAt:
          DateTime.fromMillisecondsSinceEpoch(_runStartedAt.round()),
    );
    onGameOver?.call(result);
  }

  /// Called by external code to force a crash (e.g. fuel out).
  void reportCollision() => _crash();
}
