import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../data/repositories/firestore_distribution_repository.dart';
import '../../domain/models/distribution.dart';
import '../../domain/repositories/distribution_repository.dart';
import '../../domain/services/distribution_engine.dart';

// ─── Streams ──────────────────────────────────────────────────────────────────

final distributionsProvider = StreamProvider<List<Distribution>>((ref) {
  final user = ref.watch(authUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref
      .watch(distributionRepositoryProvider)
      .watchDistributions(user.uid);
});

// ─── Engine ───────────────────────────────────────────────────────────────────

final distributionEngineProvider = Provider<DistributionEngine>((_) {
  return const DistributionEngine();
});

// ─── Controller ──────────────────────────────────────────────────────────────

class DistributionController extends StateNotifier<AsyncValue<void>> {
  DistributionController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  DistributionRepository get _repo =>
      _ref.read(distributionRepositoryProvider);

  String? get _uid => _ref.read(authUserProvider).valueOrNull?.uid;

  Distribution computeForIncome({
    required String sourceTransactionId,
    required double income,
  }) {
    final uid = _uid ?? '';
    final budget = _ref.read(budgetProvider).valueOrNull;
    final goals = _ref.read(goalsProvider).valueOrNull ?? [];
    return _ref.read(distributionEngineProvider).compute(
          uid: uid,
          sourceTransactionId: sourceTransactionId,
          income: income,
          budget: budget,
          goals: goals,
        );
  }

  Future<void> saveDistribution(Distribution distribution) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.saveDistribution(uid, distribution),
    );
  }

  Future<void> acceptDistribution(String distributionId) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.acceptDistribution(uid, distributionId),
    );
  }
}

final distributionControllerProvider =
    StateNotifierProvider<DistributionController, AsyncValue<void>>(
  DistributionController.new,
);
