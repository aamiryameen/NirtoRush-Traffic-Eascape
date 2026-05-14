import 'enums.dart';

/// Snapshot of a single play session, produced when the game ends.
class RunResult {
  final GameMode mode;
  final String mapId;
  final String vehicleId;
  final double distance; // meters
  final double topSpeed; // px/s (raw)
  final int overtakes;
  final int crashes;
  final int coinsEarned;
  final int xpEarned;
  final Duration duration;
  final int driftScore;
  final int policeEscaped;
  final int wantedLevelMax;
  final DateTime startedAt;

  const RunResult({
    required this.mode,
    required this.mapId,
    required this.vehicleId,
    required this.distance,
    required this.topSpeed,
    required this.overtakes,
    required this.crashes,
    required this.coinsEarned,
    required this.xpEarned,
    required this.duration,
    required this.driftScore,
    required this.policeEscaped,
    required this.wantedLevelMax,
    required this.startedAt,
  });

  int get score => (distance.round() * 1) +
      (overtakes * 25) +
      (driftScore) +
      (policeEscaped * 200);
}
