import 'enums.dart';

class Mission {
  final String id;
  final MissionType type;
  final String title;
  final String description;
  final int target;
  final int progress;
  final int rewardCoins;
  final int rewardGems;
  final int rewardXp;
  final MissionStatus status;
  final DateTime expiresAt;
  final String metric; // e.g. 'distance_m', 'overtake_count', 'top_speed'

  const Mission({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.target,
    this.progress = 0,
    this.rewardCoins = 0,
    this.rewardGems = 0,
    this.rewardXp = 0,
    this.status = MissionStatus.active,
    required this.expiresAt,
    required this.metric,
  });

  double get progressFraction =>
      target == 0 ? 0 : (progress / target).clamp(0.0, 1.0);

  bool get isComplete => progress >= target;

  Mission copyWith({
    int? progress,
    MissionStatus? status,
  }) =>
      Mission(
        id: id,
        type: type,
        title: title,
        description: description,
        target: target,
        progress: progress ?? this.progress,
        rewardCoins: rewardCoins,
        rewardGems: rewardGems,
        rewardXp: rewardXp,
        status: status ?? this.status,
        expiresAt: expiresAt,
        metric: metric,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'description': description,
        'target': target,
        'progress': progress,
        'rewardCoins': rewardCoins,
        'rewardGems': rewardGems,
        'rewardXp': rewardXp,
        'status': status.name,
        'expiresAt': expiresAt.toIso8601String(),
        'metric': metric,
      };

  factory Mission.fromJson(Map<String, dynamic> j) => Mission(
        id: j['id'] as String,
        type: MissionType.values.byName(j['type'] as String),
        title: j['title'] as String,
        description: j['description'] as String,
        target: j['target'] as int,
        progress: j['progress'] as int? ?? 0,
        rewardCoins: j['rewardCoins'] as int? ?? 0,
        rewardGems: j['rewardGems'] as int? ?? 0,
        rewardXp: j['rewardXp'] as int? ?? 0,
        status: MissionStatus.values.byName(j['status'] as String? ?? 'active'),
        expiresAt: DateTime.parse(j['expiresAt'] as String),
        metric: j['metric'] as String,
      );
}
