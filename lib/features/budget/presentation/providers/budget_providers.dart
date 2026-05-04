import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_budget_repository.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/budget_month.dart';
import '../../domain/models/year_type.dart';

// ─── Selected year state ──────────────────────────────────────────────────────

final selectedYearTypeProvider = StateProvider<YearType>((_) => YearType.financial);

final selectedBudgetYearProvider = StateProvider<int>((ref) {
  final now = DateTime.now();
  final yearType = ref.watch(selectedYearTypeProvider);
  return yearType == YearType.financial
      ? (now.month >= 4 ? now.year : now.year - 1)
      : now.year;
});

// ─── Budget stream ────────────────────────────────────────────────────────────

final budgetProvider = StreamProvider<Budget?>((ref) {
  final user = ref.watch(authUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final year = ref.watch(selectedBudgetYearProvider);
  return ref.watch(budgetRepositoryProvider).watchBudget(user.uid, year);
});

// ─── Budget months stream ─────────────────────────────────────────────────────

final budgetMonthsProvider = StreamProvider<List<BudgetMonth>>((ref) {
  final user = ref.watch(authUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final year = ref.watch(selectedBudgetYearProvider);
  return ref.watch(budgetRepositoryProvider).watchMonths(user.uid, year);
});

// ─── Controller ───────────────────────────────────────────────────────────────

class BudgetController extends StateNotifier<AsyncValue<void>> {
  BudgetController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> saveBudget(Budget budget) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(budgetRepositoryProvider).saveBudget(budget),
    );
  }

  Future<void> saveMonth(int year, BudgetMonth month) async {
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(budgetRepositoryProvider).saveMonth(uid, year, month),
    );
  }
}

final budgetControllerProvider =
    StateNotifierProvider<BudgetController, AsyncValue<void>>(
  BudgetController.new,
);
