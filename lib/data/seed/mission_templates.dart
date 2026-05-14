import '../models/enums.dart';
import '../models/mission.dart';

class MissionTemplates {
  MissionTemplates._();

  static List<Mission> generateDaily(DateTime now) {
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return [
      Mission(
        id: 'daily_distance_${now.millisecondsSinceEpoch}',
        type: MissionType.daily,
        title: 'Road Warrior',
        description: 'Drive 10 km in any mode',
        target: 10000,
        rewardCoins: 500,
        rewardXp: 200,
        expiresAt: tomorrow,
        metric: 'distance_m',
      ),
      Mission(
        id: 'daily_speed_${now.millisecondsSinceEpoch}',
        type: MissionType.daily,
        title: 'Speed Demon',
        description: 'Reach 250 km/h',
        target: 250,
        rewardCoins: 400,
        rewardXp: 150,
        expiresAt: tomorrow,
        metric: 'top_speed_kmh',
      ),
      Mission(
        id: 'daily_overtake_${now.millisecondsSinceEpoch}',
        type: MissionType.daily,
        title: 'Overtake King',
        description: 'Overtake 30 vehicles',
        target: 30,
        rewardCoins: 600,
        rewardXp: 250,
        expiresAt: tomorrow,
        metric: 'overtake_count',
      ),
    ];
  }

  static List<Mission> generateWeekly(DateTime now) {
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = DateTime(monday.year, monday.month, monday.day).add(const Duration(days: 7));
    return [
      Mission(
        id: 'weekly_escape_${monday.millisecondsSinceEpoch}',
        type: MissionType.weekly,
        title: 'Escape Artist',
        description: 'Escape police 5 times',
        target: 5,
        rewardCoins: 3000,
        rewardGems: 25,
        rewardXp: 1000,
        expiresAt: endOfWeek,
        metric: 'police_escaped',
      ),
      Mission(
        id: 'weekly_races_${monday.millisecondsSinceEpoch}',
        type: MissionType.weekly,
        title: 'Veteran Driver',
        description: 'Complete 20 runs',
        target: 20,
        rewardCoins: 2500,
        rewardGems: 15,
        rewardXp: 800,
        expiresAt: endOfWeek,
        metric: 'runs_completed',
      ),
      Mission(
        id: 'weekly_coins_${monday.millisecondsSinceEpoch}',
        type: MissionType.weekly,
        title: 'Cash Collector',
        description: 'Earn 50,000 coins',
        target: 50000,
        rewardCoins: 5000,
        rewardGems: 50,
        rewardXp: 1500,
        expiresAt: endOfWeek,
        metric: 'coins_earned',
      ),
    ];
  }
}
