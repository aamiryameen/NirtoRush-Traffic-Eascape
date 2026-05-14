import 'package:uuid/uuid.dart';
import '../data/models/enums.dart';
import '../data/models/player_profile.dart';

/// Authentication service. Currently supports guest login locally.
/// To wire Supabase: uncomment supabase_flutter in pubspec, then implement
/// signInWithGoogle / signInAsGuest with real calls.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _uuid = Uuid();

  PlayerProfile createGuestProfile() {
    final now = DateTime.now();
    return PlayerProfile(
      id: _uuid.v4(),
      username: 'Racer${(now.millisecondsSinceEpoch % 9999).toString().padLeft(4, '0')}',
      authProvider: AuthProvider.guest,
      createdAt: now,
      lastLoginAt: now,
    );
  }

  Future<PlayerProfile> signInAsGuest() async {
    // Local-only. Future: persist to Supabase auth.users via anon sign-in.
    return createGuestProfile();
  }

  Future<PlayerProfile> signInWithGoogle() async {
    // TODO: integrate google_sign_in + Supabase OAuth.
    throw UnimplementedError('Google sign-in requires Supabase OAuth setup.');
  }

  Future<void> signOut() async {
    // Local-only no-op for now.
  }
}
