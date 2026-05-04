import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../accounts/presentation/providers/account_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_monthly_obligation_repository.dart';
import '../../domain/models/monthly_obligation.dart';
import '../../domain/models/obligation_priority.dart';
import '../../domain/models/obligation_summary.dart';
import '../../domain/repositories/monthly_obligation_repository.dart';

// ── Selected month state ──────────────────────────────────────────────────────

final selectedObligationYearProvider = StateProvider<int>((ref) {
  return DateTime.now().year;
});

final selectedObligationMonthProvider = StateProvider<int>((ref) {
  return DateTime.now().month;
});

// ── Stream ────────────────────────────────────────────────────────────────────

final obligationsProvider =
    StreamProvider.family<List<MonthlyObligation>, (int, int)>(
        (ref, params) {
  final (year, month) = params;
  return ref
      .watch(monthlyObligationRepositoryProvider)
      .watchByMonth(year, month);
});

// ── Summary (derived) ─────────────────────────────────────────────────────────

final obligationSummaryProvider =
    Provider.family<ObligationSummary, (int, int)>((ref, params) {
  final obligations =
      ref.watch(obligationsProvider(params)).valueOrNull ?? [];
  final totalBalance = ref.watch(totalBalanceProvider);

  return ObligationSummary(
    totalIncome: totalBalance,
    obligations: obligations,
  );
});

// ── Controller ────────────────────────────────────────────────────────────────

final obligationControllerProvider =
    StateNotifierProvider<ObligationController, AsyncValue<void>>(
  (ref) => ObligationController(
    ref.watch(monthlyObligationRepositoryProvider),
    ref,
  ),
);

class ObligationController extends StateNotifier<AsyncValue<void>> {
  ObligationController(this._repo, this._ref)
      : super(const AsyncData(null));

  final MonthlyObligationRepository _repo;
  final Ref _ref;
  final _uuid = const Uuid();

  Future<void> add({
    required String label,
    required double amount,
    required int year,
    required int month,
    int dueDay = 1,
    ObligationPriority priority = ObligationPriority.medium,
    String notes = '',
  }) async {
    state = const AsyncLoading();
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    final obligation = MonthlyObligation(
      id: _uuid.v4(),
      uid: uid,
      label: label,
      amount: amount,
      year: year,
      month: month,
      dueDay: dueDay,
      priority: priority,
      notes: notes,
    );
    state = await AsyncValue.guard(() => _repo.add(obligation));
  }

  Future<void> update(MonthlyObligation obligation) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.update(obligation));
  }

  Future<void> togglePaid(MonthlyObligation obligation) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _repo.update(obligation.copyWith(isPaid: !obligation.isPaid)));
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.delete(id));
  }

  Future<void> carryOver({
    required List<MonthlyObligation> unpaidObligations,
    required int toYear,
    required int toMonth,
  }) async {
    state = const AsyncLoading();
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    state = await AsyncValue.guard(() async {
      for (final o in unpaidObligations) {
        await _repo.add(MonthlyObligation(
          id: _uuid.v4(),
          uid: uid,
          label: o.label,
          amount: o.amount,
          year: toYear,
          month: toMonth,
          dueDay: o.dueDay,
          priority: o.priority,
          notes: o.notes,
        ));
      }
    });
  }
}
