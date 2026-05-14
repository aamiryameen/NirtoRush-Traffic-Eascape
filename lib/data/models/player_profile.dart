import 'enums.dart';

class PlayerProfile {
  final String id;
  final String username;
  final AuthProvider authProvider;
  final int xp;
  final int level;
  final String? avatarUrl;
  final String? countryCode;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final int dailyLoginStreak;
  final DateTime? lastDailyClaim;

  const PlayerProfile({
    required this.id,
    required this.username,
    this.authProvider = AuthProvider.guest,
    this.xp = 0,
    this.level = 1,
    this.avatarUrl,
    this.countryCode,
    required this.createdAt,
    required this.lastLoginAt,
    this.dailyLoginStreak = 0,
    this.lastDailyClaim,
  });

  /// Smooth level curve: level = floor(sqrt(xp / 100)) + 1
  static int levelFromXp(int xp) {
    var lvl = 1;
    var cum = 0;
    while (cum + xpForLevel(lvl) <= xp) {
      cum += xpForLevel(lvl);
      lvl++;
    }
    return lvl;
  }

  static int xpForLevel(int level) => 100 + (level - 1) * 75;

  int get xpIntoLevel {
    var cum = 0;
    for (var i = 1; i < level; i++) {
      cum += xpForLevel(i);
    }
    return xp - cum;
  }

  int get xpToNext => xpForLevel(level);

  PlayerProfile copyWith({
    String? username,
    AuthProvider? authProvider,
    int? xp,
    int? level,
    String? avatarUrl,
    String? countryCode,
    DateTime? lastLoginAt,
    int? dailyLoginStreak,
    DateTime? lastDailyClaim,
  }) =>
      PlayerProfile(
        id: id,
        username: username ?? this.username,
        authProvider: authProvider ?? this.authProvider,
        xp: xp ?? this.xp,
        level: level ?? this.level,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        countryCode: countryCode ?? this.countryCode,
        createdAt: createdAt,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        dailyLoginStreak: dailyLoginStreak ?? this.dailyLoginStreak,
        lastDailyClaim: lastDailyClaim ?? this.lastDailyClaim,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'authProvider': authProvider.name,
        'xp': xp,
        'level': level,
        'avatarUrl': avatarUrl,
        'countryCode': countryCode,
        'createdAt': createdAt.toIso8601String(),
        'lastLoginAt': lastLoginAt.toIso8601String(),
        'dailyLoginStreak': dailyLoginStreak,
        'lastDailyClaim': lastDailyClaim?.toIso8601String(),
      };

  factory PlayerProfile.fromJson(Map<String, dynamic> j) => PlayerProfile(
        id: j['id'] as String,
        username: j['username'] as String,
        authProvider: AuthProvider.values.byName(j['authProvider'] as String? ?? 'guest'),
        xp: j['xp'] as int? ?? 0,
        level: j['level'] as int? ?? 1,
        avatarUrl: j['avatarUrl'] as String?,
        countryCode: j['countryCode'] as String?,
        createdAt: DateTime.parse(j['createdAt'] as String),
        lastLoginAt: DateTime.parse(j['lastLoginAt'] as String),
        dailyLoginStreak: j['dailyLoginStreak'] as int? ?? 0,
        lastDailyClaim: j['lastDailyClaim'] != null
            ? DateTime.parse(j['lastDailyClaim'] as String)
            : null,
      );
}
