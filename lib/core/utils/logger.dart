import 'dart:developer' as developer;

/// Lightweight logger wrapper. Swap to package:logger in production if desired.
class Log {
  Log._();

  static void d(String tag, String msg) => developer.log(msg, name: tag, level: 500);
  static void i(String tag, String msg) => developer.log(msg, name: tag, level: 800);
  static void w(String tag, String msg) => developer.log(msg, name: tag, level: 900);
  static void e(String tag, String msg, [Object? error, StackTrace? st]) =>
      developer.log(msg, name: tag, level: 1000, error: error, stackTrace: st);
}
