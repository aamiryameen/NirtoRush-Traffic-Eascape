import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../data/models/economy.dart';
import '../data/models/enums.dart';
import '../services/local_storage.dart';

class EconomyNotifier extends StateNotifier<Wallet> {
  EconomyNotifier()
      : super(Wallet(
          coins: AppConstants.startingCoins,
          gems: AppConstants.startingGems,
          fuel: AppConstants.maxFuel,
          lastFuelTickAt: DateTime.now(),
        ));

  Future<void> load() async {
    final raw = LocalStorage.instance.readWallet();
    if (raw != null) {
      state = Wallet.fromJson(raw);
      await _regenFuel();
    } else {
      await _persist();
    }
  }

  Future<void> _persist() => LocalStorage.instance.writeWallet(state.toJson());

  Future<void> add(CurrencyType type, int amount) async {
    state = state.add(type, amount);
    await _persist();
  }

  /// Returns false if insufficient funds.
  Future<bool> spend(CurrencyType type, int amount) async {
    if (state.amount(type) < amount) return false;
    state = state.add(type, -amount);
    await _persist();
    return true;
  }

  Future<void> _regenFuel() async {
    final now = DateTime.now();
    final elapsed = now.difference(state.lastFuelTickAt).inSeconds;
    final ticks = elapsed ~/ AppConstants.fuelRegenSeconds;
    if (ticks <= 0) return;
    final newFuel =
        (state.fuel + ticks).clamp(0, AppConstants.maxFuel);
    state = state.copyWith(
      fuel: newFuel,
      lastFuelTickAt: state.lastFuelTickAt
          .add(Duration(seconds: ticks * AppConstants.fuelRegenSeconds)),
    );
    await _persist();
  }

  Future<bool> consumeFuel([int amount = 1]) async {
    if (state.fuel < amount) return false;
    state = state.copyWith(fuel: state.fuel - amount);
    await _persist();
    return true;
  }

  Future<void> tick() => _regenFuel();
}

final economyProvider =
    StateNotifierProvider<EconomyNotifier, Wallet>((ref) => EconomyNotifier());
