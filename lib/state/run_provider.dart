import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/enums.dart';
import '../data/models/run_result.dart';

/// Holds the most recent run's result, so the Results screen can render
/// it after the gameplay screen navigates away.
class RunResultNotifier extends StateNotifier<RunResult?> {
  RunResultNotifier() : super(null);

  void set(RunResult r) => state = r;
  void clear() => state = null;
}

final runResultProvider =
    StateNotifierProvider<RunResultNotifier, RunResult?>((ref) => RunResultNotifier());

/// Selected mode for the next run.
final selectedModeProvider = StateProvider<GameMode>((ref) => GameMode.endlessHighway);
