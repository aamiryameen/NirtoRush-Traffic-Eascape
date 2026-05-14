import '../models/live_event.dart';

class EventSeed {
  EventSeed._();

  static List<LiveEvent> currentEvents() {
    final now = DateTime.now();
    return [
      LiveEvent(
        id: 'neon_nights',
        name: 'Neon Nights',
        description: 'Race through the cyber city for exclusive rewards.',
        themeMapId: 'neon_city',
        startsAt: now.subtract(const Duration(days: 1)),
        endsAt: now.add(const Duration(days: 6)),
        rewardEventTokens: 1000,
        milestones: const [
          EventMilestone(threshold: 5000, rewardCoins: 500),
          EventMilestone(threshold: 15000, rewardCoins: 1500, rewardGems: 25),
          EventMilestone(threshold: 30000, rewardVehicleId: 'hyper_neonx'),
        ],
      ),
      LiveEvent(
        id: 'desert_rush',
        name: 'Desert Rush',
        description: 'Escape the sandstorm. Limited-time desert challenge.',
        themeMapId: 'desert',
        startsAt: now.add(const Duration(days: 7)),
        endsAt: now.add(const Duration(days: 14)),
        rewardEventTokens: 800,
      ),
    ];
  }
}
