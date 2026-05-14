import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/enums.dart';
import '../data/models/vehicle.dart';
import '../data/seed/vehicle_catalog.dart';
import '../services/local_storage.dart';
import 'economy_provider.dart';

class GarageState {
  final List<OwnedVehicle> owned;
  final String selectedVehicleId;
  final String selectedMapId;

  const GarageState({
    required this.owned,
    required this.selectedVehicleId,
    required this.selectedMapId,
  });

  GarageState copyWith({
    List<OwnedVehicle>? owned,
    String? selectedVehicleId,
    String? selectedMapId,
  }) =>
      GarageState(
        owned: owned ?? this.owned,
        selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
        selectedMapId: selectedMapId ?? this.selectedMapId,
      );

  OwnedVehicle? ownedById(String id) {
    for (final v in owned) {
      if (v.vehicleId == id) return v;
    }
    return null;
  }

  bool isOwned(String id) => ownedById(id) != null;

  OwnedVehicle get selected => ownedById(selectedVehicleId) ?? owned.first;
}

class GarageNotifier extends StateNotifier<GarageState> {
  GarageNotifier(this.ref)
      : super(GarageState(
          owned: [
            OwnedVehicle(
              vehicleId: VehicleCatalog.starterId,
              unlockedAt: DateTime.now(),
            ),
          ],
          selectedVehicleId: VehicleCatalog.starterId,
          selectedMapId: 'city_highway',
        ));

  final Ref ref;

  Future<void> load() async {
    final ownedRaw = LocalStorage.instance.readOwnedVehicles();
    final selected = LocalStorage.instance.readSelectedVehicleId();
    final selectedMap = LocalStorage.instance.readSelectedMapId();
    if (ownedRaw.isEmpty) {
      await _persist();
      return;
    }
    state = state.copyWith(
      owned: ownedRaw.map(OwnedVehicle.fromJson).toList(),
      selectedVehicleId: selected ?? VehicleCatalog.starterId,
      selectedMapId: selectedMap ?? 'city_highway',
    );
  }

  Future<void> _persist() async {
    await LocalStorage.instance
        .writeOwnedVehicles(state.owned.map((e) => e.toJson()).toList());
    await LocalStorage.instance.writeSelectedVehicleId(state.selectedVehicleId);
    await LocalStorage.instance.writeSelectedMapId(state.selectedMapId);
  }

  Future<void> selectVehicle(String id) async {
    if (!state.isOwned(id)) return;
    state = state.copyWith(selectedVehicleId: id);
    await _persist();
  }

  Future<void> selectMap(String id) async {
    state = state.copyWith(selectedMapId: id);
    await _persist();
  }

  /// Returns true on successful unlock.
  Future<bool> buyVehicle(Vehicle v) async {
    if (state.isOwned(v.id)) return false;
    final econ = ref.read(economyProvider.notifier);
    if (v.priceGems > 0) {
      final ok = await econ.spend(CurrencyType.gems, v.priceGems);
      if (!ok) return false;
    }
    if (v.priceCoins > 0) {
      final ok = await econ.spend(CurrencyType.coins, v.priceCoins);
      if (!ok) return false;
    }
    state = state.copyWith(owned: [
      ...state.owned,
      OwnedVehicle(vehicleId: v.id, unlockedAt: DateTime.now()),
    ]);
    await _persist();
    return true;
  }

  Future<bool> upgrade(String id, String upgradeKey, int costCoins) async {
    final owned = state.ownedById(id);
    if (owned == null) return false;
    final econ = ref.read(economyProvider.notifier);
    if (!await econ.spend(CurrencyType.coins, costCoins)) return false;

    final u = owned.upgrades;
    VehicleUpgrades next;
    switch (upgradeKey) {
      case 'engine':
        if (u.engineLevel >= 10) return false;
        next = u.copyWith(engineLevel: u.engineLevel + 1);
        break;
      case 'turbo':
        if (u.turboLevel >= 10) return false;
        next = u.copyWith(turboLevel: u.turboLevel + 1);
        break;
      case 'tires':
        if (u.tiresLevel >= 10) return false;
        next = u.copyWith(tiresLevel: u.tiresLevel + 1);
        break;
      case 'brakes':
        if (u.brakesLevel >= 10) return false;
        next = u.copyWith(brakesLevel: u.brakesLevel + 1);
        break;
      case 'suspension':
        if (u.suspensionLevel >= 10) return false;
        next = u.copyWith(suspensionLevel: u.suspensionLevel + 1);
        break;
      default:
        return false;
    }
    final updated = state.owned
        .map((e) => e.vehicleId == id ? e.copyWith(upgrades: next) : e)
        .toList();
    state = state.copyWith(owned: updated);
    await _persist();
    return true;
  }

  Future<void> applyCustomization(String id, VehicleCustomization c) async {
    final updated = state.owned
        .map((e) => e.vehicleId == id ? e.copyWith(customization: c) : e)
        .toList();
    state = state.copyWith(owned: updated);
    await _persist();
  }
}

final garageProvider =
    StateNotifierProvider<GarageNotifier, GarageState>((ref) => GarageNotifier(ref));
