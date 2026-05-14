class LiveEvent {
  final String id;
  final String name;
  final String description;
  final String themeMapId;
  final DateTime startsAt;
  final DateTime endsAt;
  final int rewardEventTokens;
  final List<EventMilestone> milestones;

  const LiveEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.themeMapId,
    required this.startsAt,
    required this.endsAt,
    this.rewardEventTokens = 0,
    this.milestones = const [],
  });

  bool get isLive {
    final now = DateTime.now();
    return now.isAfter(startsAt) && now.isBefore(endsAt);
  }

  Duration get timeRemaining => endsAt.difference(DateTime.now());
}

class EventMilestone {
  final int threshold;
  final int rewardCoins;
  final int rewardGems;
  final String? rewardVehicleId;

  const EventMilestone({
    required this.threshold,
    this.rewardCoins = 0,
    this.rewardGems = 0,
    this.rewardVehicleId,
  });
}
