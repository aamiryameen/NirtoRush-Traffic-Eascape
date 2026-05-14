import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticsService {
  HapticsService._();
  static final HapticsService instance = HapticsService._();

  bool enabled = true;

  Future<void> light() async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> medium() async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }

  Future<void> heavy() async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }

  Future<void> crash() async {
    if (!enabled) return;
    final hasVib = await Vibration.hasVibrator();
    if (hasVib) {
      Vibration.vibrate(pattern: [0, 80, 60, 120]);
    } else {
      await HapticFeedback.heavyImpact();
    }
  }
}
