/// Centralized secrets / external credentials.
///
/// Fill these in before enabling Supabase / AdMob / Firebase in pubspec.yaml.
/// Do NOT commit real credentials. Add this file to .gitignore once populated.
class Secrets {
  Secrets._();

  // ===== Supabase =====
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // ===== AdMob =====
  static const String admobAppId = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
  static const String admobBannerUnitId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobInterstitialUnitId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobRewardedUnitId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String admobAppOpenUnitId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // ===== Firebase =====
  // Populate via flutterfire configure or paste manually.
  static const bool firebaseEnabled = false;

  // ===== Save encryption =====
  // 32-byte base64 string. Regenerate before production release.
  static const String saveEncryptionKeyBase64 =
      'qZ4Tn5J6vN8mK1bL3wXa9cD0eF2gH4iJ6kL8mN0oP2Q=';
}
