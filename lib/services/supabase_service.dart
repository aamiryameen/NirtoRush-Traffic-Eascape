import '../config/feature_flags.dart';
import '../core/utils/logger.dart';
import '../data/models/leaderboard_entry.dart';

/// Supabase facade. Stubbed until [FeatureFlags.supabaseEnabled] is true and
/// `supabase_flutter` is added to pubspec.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  static const _tag = 'Supabase';

  Future<void> init() async {
    if (!FeatureFlags.supabaseEnabled) {
      Log.i(_tag, 'Supabase disabled — running offline');
      return;
    }
    // await Supabase.initialize(url: Secrets.supabaseUrl, anonKey: Secrets.supabaseAnonKey);
  }

  Future<void> uploadSave(Map<String, dynamic> save) async {
    if (!FeatureFlags.supabaseEnabled) return;
  }

  Future<Map<String, dynamic>?> downloadSave() async {
    if (!FeatureFlags.supabaseEnabled) return null;
    return null;
  }

  Future<void> submitScore(int score, double distance, String mode) async {
    if (!FeatureFlags.supabaseEnabled) return;
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard({
    String scope = 'global',
    int limit = 50,
  }) async {
    if (!FeatureFlags.supabaseEnabled) return _mockLeaderboard(limit);
    return _mockLeaderboard(limit);
  }

  // Mock data so the leaderboard screen has something to render offline.
  List<LeaderboardEntry> _mockLeaderboard(int limit) {
    const names = [
      'NeoDrift', 'AceTurbo', 'V8Vandal', 'NitroQueen', 'ShadowLane',
      'BlitzKid', 'FrostByte', 'CyberDash', 'TurboGhost', 'ApexRider'
    ];
    return List.generate(
      limit,
      (i) => LeaderboardEntry(
        rank: i + 1,
        playerId: 'mock_$i',
        username: names[i % names.length] + (i ~/ names.length > 0 ? '${i ~/ names.length}' : ''),
        countryCode: ['US', 'PK', 'JP', 'DE', 'BR', 'IN'][i % 6],
        score: 250000 - i * 5300,
        distance: 12000 - i * 280.0,
        level: (40 - i ~/ 2).clamp(1, 99),
      ),
    );
  }
}
