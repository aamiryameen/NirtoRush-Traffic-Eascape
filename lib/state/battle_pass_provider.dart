import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/battle_pass.dart';
import '../data/seed/battle_pass_seed.dart';
import '../services/local_storage.dart';

class BattlePassNotifier extends StateNotifier<BattlePassState> {
  BattlePassNotifier() : super(BattlePassSeed.defaultSeason());

  Future<void> load() async {
    final raw = LocalStorage.instance.readBattlePass();
    if (raw != null) {
      state = BattlePassState.fromJson(raw);
    } else {
      await _persist();
    }
  }

  Future<void> _persist() =>
      LocalStorage.instance.writeBattlePass(state.toJson());

  Future<void> addXp(int xp) async {
    final newXp = state.xp + xp;
    final newTier =
        (newXp ~/ BattlePassState.xpPerTier + 1).clamp(1, BattlePassState.maxTier);
    state = state.copyWith(xp: newXp, tier: newTier);
    await _persist();
  }

  Future<void> unlockPremium() async {
    state = state.copyWith(premiumUnlocked: true);
    await _persist();
  }

  Future<void> claimTier(int tier, {required bool premium}) async {
    if (state.tier < tier) return;
    if (premium && !state.premiumUnlocked) return;
    if (premium) {
      state = state
          .copyWith(claimedPremiumTiers: {...state.claimedPremiumTiers, tier});
    } else {
      state =
          state.copyWith(claimedFreeTiers: {...state.claimedFreeTiers, tier});
    }
    await _persist();
  }
}

final battlePassProvider =
    StateNotifierProvider<BattlePassNotifier, BattlePassState>(
        (ref) => BattlePassNotifier());
