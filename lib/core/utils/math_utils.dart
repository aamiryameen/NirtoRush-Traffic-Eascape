import 'dart:math';

class MathUtils {
  MathUtils._();

  static double clamp(double v, double min, double max) =>
      v < min ? min : (v > max ? max : v);

  static double lerp(double a, double b, double t) => a + (b - a) * t.clamp(0.0, 1.0);

  static double smoothstep(double edge0, double edge1, double x) {
    final t = ((x - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
    return t * t * (3.0 - 2.0 * t);
  }

  static int randomInt(int min, int maxExclusive, [Random? rng]) {
    final r = rng ?? Random();
    return min + r.nextInt(maxExclusive - min);
  }

  static T pickWeighted<T>(List<T> items, List<double> weights, [Random? rng]) {
    assert(items.length == weights.length);
    final r = rng ?? Random();
    final total = weights.reduce((a, b) => a + b);
    double pick = r.nextDouble() * total;
    for (var i = 0; i < items.length; i++) {
      pick -= weights[i];
      if (pick <= 0) return items[i];
    }
    return items.last;
  }
}
