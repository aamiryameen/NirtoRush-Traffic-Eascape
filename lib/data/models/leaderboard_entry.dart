class LeaderboardEntry {
  final int rank;
  final String playerId;
  final String username;
  final String? countryCode;
  final int score;
  final double distance;
  final int level;

  const LeaderboardEntry({
    required this.rank,
    required this.playerId,
    required this.username,
    this.countryCode,
    required this.score,
    required this.distance,
    required this.level,
  });
}
