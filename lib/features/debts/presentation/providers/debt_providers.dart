import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_debt_repository.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_type.dart';
import '../../domain/repositories/debt_repository.dart';

// ── Streams ───────────────────────────────────────────────────────────────────

final debtsProvider = StreamProvider<List<Debt>>((ref) {
  return ref.watch(debtRepositoryProvider).watchAll();
});

// ── Controller ────────────────────────────────────────────────────────────────

final debtControllerProvider =
    StateNotifierProvider<DebtController, AsyncValue<void>>(
  (ref) => DebtController(ref.watch(debtRepositoryProvider), ref),
);

class DebtController extends StateNotifier<AsyncValue<void>> {
  DebtController(this._repo, this._ref) : super(const AsyncData(null));

  final DebtRepository _repo;
  final Ref _ref;
  final _uuid = const Uuid();

  Future<void> add({
    required String label,
    required DebtType type,
    required double outstanding,
    required double interestRatePercent,
    required double minimumPayment,
    int dueDay = 1,
    String? linkedAccountId,
    double? creditLimit,
  }) async {
    state = const AsyncLoading();
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    final debt = Debt(
      id: _uuid.v4(),
      uid: uid,
      label: label,
      type: type,
      outstanding: outstanding,
      interestRatePercent: interestRatePercent,
      minimumPayment: minimumPayment,
      dueDay: dueDay,
      linkedAccountId: linkedAccountId,
      creditLimit: creditLimit,
    );
    state = await AsyncValue.guard(() => _repo.add(debt));
  }

  Future<void> update(Debt debt) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.update(debt));
  }

  Future<void> delete(String debtId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.delete(debtId));
  }
}
