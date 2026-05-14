# NitroRush: Traffic Escape

> Hybrid-casual arcade racing game — endless highway, traffic dodging, police chases.
> Built with **Flutter + Flame**. **Android only.**

Inspired by Traffic Rider, Traffic Racer, and arcade-style Need for Speed / Asphalt mechanics.

---

## Status

Early development. The core gameplay loop, full UI, local persistence, and a
stubbed service layer are in place. Backend/ads/analytics integrations are
wired behind feature flags and disabled by default so the app runs fully
offline during development.

## Tech Stack

| Layer            | Technology                          |
|------------------|-------------------------------------|
| Game engine      | Flame                               |
| App framework    | Flutter (Android only)              |
| State management | Riverpod                            |
| Local storage    | Hive + SharedPreferences            |
| Audio            | audioplayers / flame_audio          |
| Animations       | Rive, flutter_animate, Lottie       |
| Backend (opt-in) | Supabase — auth, DB, realtime       |
| Ads (opt-in)     | Google Mobile Ads (AdMob)           |
| Messaging/crash  | Firebase Messaging / Crashlytics    |

Opt-in integrations are commented out in [`pubspec.yaml`](pubspec.yaml) and
gated by [`lib/config/feature_flags.dart`](lib/config/feature_flags.dart).

## Project Structure

```
lib/
  config/      Feature flags + secrets (placeholders only)
  core/        Theme, constants, formatting utilities
  data/
    models/    Vehicle, Mission, Wallet, BattlePass, LiveEvent, profile…
    seed/      Static catalogs — vehicles, maps, missions, battle pass
  services/    Auth, Ads, Analytics, Supabase, Notifications, Audio, Save
  state/       Riverpod providers (player, economy, garage, missions…)
  game/        Flame engine — road, traffic AI, police, coins, nitro, VFX
  ui/
    screens/   Splash, Login, Home, Garage, Gameplay, Shop, Events…
    widgets/   Shared UI components
```

## Getting Started

Requires the Flutter SDK (Dart `^3.11`) and an Android device or emulator.

```bash
flutter pub get
flutter run                 # debug build on a connected Android device
```

### Building an APK

```bash
flutter build apk --release                    # single APK
flutter build apk --release --split-per-abi     # smaller per-architecture APKs
```

Output: `build/app/outputs/flutter-apk/`.

> The release build is currently signed with the **debug keystore** so
> `flutter run --release` works out of the box. A real signing config is
> required before a Play Store upload — see
> [`android/app/build.gradle.kts`](android/app/build.gradle.kts).

## Enabling Backend / Ads / Firebase

1. Uncomment the relevant packages in [`pubspec.yaml`](pubspec.yaml).
2. Add credentials in [`lib/config/secrets.dart`](lib/config/secrets.dart)
   — **never commit real keys**.
3. Flip the matching flag in
   [`lib/config/feature_flags.dart`](lib/config/feature_flags.dart).
4. Implement the live calls in the corresponding `lib/services/` class.

## Controls

| Action | Input                                      |
|--------|--------------------------------------------|
| Steer  | Drag anywhere — the car follows the finger |
| Nitro  | Bottom-right button                        |
| Brake  | Bottom-left button                         |

## License

Proprietary — all rights reserved.
