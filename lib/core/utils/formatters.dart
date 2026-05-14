import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String compactNumber(num value) {
    if (value < 1000) return value.toStringAsFixed(0);
    if (value < 1_000_000) return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    if (value < 1_000_000_000) return '${(value / 1_000_000).toStringAsFixed(1)}M';
    return '${(value / 1_000_000_000).toStringAsFixed(1)}B';
  }

  static String distance(double meters) {
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  static String speedKmh(double speedPx) {
    // gameplay speed (px/s) → display kmh, tuned by AppConstants base/max.
    final kmh = (speedPx * 0.625).clamp(0, 999);
    return kmh.toStringAsFixed(0);
  }

  static String duration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) return '${d.inHours}:$minutes:$seconds';
    return '$minutes:$seconds';
  }

  static String dateShort(DateTime dt) => DateFormat('MMM d').format(dt);
}
