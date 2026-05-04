import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../data/repositories/firestore_asset_repository.dart';
import '../../data/repositories/firestore_snapshot_repository.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/asset_type.dart';
import '../../domain/models/net_worth_snapshot.dart';

// ── Streams ───────────────────────────────────────────────────────────────────

final assetsProvider = StreamProvider<List<Asset>>((ref) {
  return ref.watch(assetRepositoryProvider).watchAll();
});

final netWorthSnapshotsProvider = StreamProvider<List<NetWorthSnapshot>>((ref) {
  return ref.watch(snapshotRepositoryProvider).watchRecent();
});

// ── Computed net worth ─────────────────────────────────────────────────────────

class NetWorthSummary {
  const NetWorthSummary({
    required this.totalAssets,
    required this.manualAssets,
    required this.goalSavings,
    required this.totalLiabilities,
    required this.netWorth,
  });

  final double totalAssets;
  final double manualAssets;
  final double goalSavings;
  final double totalLiabilities;
  final double netWorth;
}

final netWorthSummaryProvider = Provider<NetWorthSummary>((ref) {
  final assets = ref.watch(assetsProvider).valueOrNull ?? [];
  final goals = ref.watch(goalsProvider).valueOrNull ?? [];
  final debts = ref.watch(debtsProvider).valueOrNull ?? [];

  final manualAssets = assets.fold(0.0, (s, a) => s + a.value);
  final goalSavings = goals.fold(0.0, (s, g) => s + g.currentSaved);
  final totalAssets = manualAssets + goalSavings;
  final totalLiabilities = debts.fold(0.0, (s, d) => s + d.outstanding);

  return NetWorthSummary(
    totalAssets: totalAssets,
    manualAssets: manualAssets,
    goalSavings: goalSavings,
    totalLiabilities: totalLiabilities,
    netWorth: totalAssets - totalLiabilities,
  );
});

// ── Controller ────────────────────────────────────────────────────────────────

final assetControllerProvider =
    StateNotifierProvider<AssetController, AsyncValue<void>>(
  AssetController.new,
);

class AssetController extends StateNotifier<AsyncValue<void>> {
  AssetController(this._ref) : super(const AsyncData(null));

  final Ref _ref;
  final _uuid = const Uuid();

  Future<void> add({
    required String label,
    required AssetType type,
    required double value,
  }) async {
    state = const AsyncLoading();
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    final asset = Asset(
      id: _uuid.v4(),
      uid: uid,
      label: label,
      type: type,
      value: value,
    );
    state = await AsyncValue.guard(() => _ref.read(assetRepositoryProvider).add(asset));
  }

  Future<void> update(Asset asset) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _ref.read(assetRepositoryProvider).update(asset));
  }

  Future<void> delete(String assetId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _ref.read(assetRepositoryProvider).delete(assetId));
  }

  Future<void> saveSnapshot() async {
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    if (uid.isEmpty) return;
    final summary = _ref.read(netWorthSummaryProvider);
    final now = DateTime.now();
    final id = DateFormat('yyyy-MM').format(now);
    final snapshot = NetWorthSnapshot(
      id: id,
      uid: uid,
      totalAssets: summary.totalAssets,
      totalLiabilities: summary.totalLiabilities,
      netWorth: summary.netWorth,
      capturedAt: now,
    );
    await _ref.read(snapshotRepositoryProvider).save(snapshot);
  }
}
