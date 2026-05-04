import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/data/services/category_matcher.dart';
import '../../../transactions/domain/models/transaction.dart';
import '../../../transactions/domain/models/transaction_type.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';

// Currently selected month (defaults to now)
final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month),
);

// Monthly summary for the selected month
final monthlySummaryProvider = Provider<MonthlySummary>((ref) {
  final month = ref.watch(selectedMonthProvider);
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  return MonthlySummary.from(txns, month);
});

// Last 6 months income series (oldest → newest)
final incomeSeriesProvider = Provider<List<MonthRate>>((ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return List.generate(6, (i) {
    final month = DateTime(now.year, now.month - (5 - i));
    return MonthRate(month: month, rate: MonthlySummary.from(txns, month).income);
  });
});

// Last 6 months savings rate series (oldest → newest)
final savingsRateSeriesProvider = Provider<List<MonthRate>>((ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return List.generate(6, (i) {
    final month = DateTime(now.year, now.month - (5 - i));
    final summary = MonthlySummary.from(txns, month);
    return MonthRate(month: month, rate: summary.savingsRate);
  });
});

// Top N expense categories for selected month
final topCategoriesProvider = Provider<List<CategorySpend>>((ref) {
  final month = ref.watch(selectedMonthProvider);
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final cats = ref.watch(categoriesProvider).valueOrNull ?? [];

  final expenses = txns.where((t) =>
      t.type == TransactionType.expense && _sameMonth(t.date, month));

  final knownIds = cats.map((c) => c.id).toSet();
  final totals = <String, double>{};
  for (final t in expenses) {
    final matched = CategoryMatcher.matchCategoryId(t.description);
    final catId = matched ??
        (knownIds.contains(t.categoryId) ? t.categoryId : 'cat_uncategorized');
    totals[catId] = (totals[catId] ?? 0.0) + t.amount;
  }

  final result = totals.entries.map((e) {
    final cat = cats.where((c) => c.id == e.key).firstOrNull;
    return CategorySpend(
      categoryId: e.key,
      name: cat?.name ?? 'Uncategorized',
      colorValue: cat?.colorValue ?? 0xFF90A4AE,
      amount: e.value,
    );
  }).toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  return result.take(8).toList();
});

// Recent transactions (last 5) for selected month
final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final month = ref.watch(selectedMonthProvider);
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  return txns
      .where((t) => _sameMonth(t.date, month))
      .take(5)
      .toList();
});

bool _sameMonth(DateTime date, DateTime month) =>
    date.year == month.year && date.month == month.month;

// ─── Data classes ─────────────────────────────────────────────────────────────

class MonthlySummary {
  const MonthlySummary({
    required this.income,
    required this.expense,
  });

  final double income;
  final double expense;

  double get net => income - expense;

  double get savingsRate {
    if (income <= 0) return 0;
    final rate = net / income * 100;
    return rate.clamp(0.0, 100.0);
  }

  static MonthlySummary from(List<Transaction> txns, DateTime month) {
    double income = 0.0;
    double expense = 0.0;
    for (final t in txns) {
      if (!_sameMonth(t.date, month)) continue;
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return MonthlySummary(income: income, expense: expense);
  }
}

class MonthRate {
  const MonthRate({required this.month, required this.rate});
  final DateTime month;
  final double rate;
}

class CategorySpend {
  const CategorySpend({
    required this.categoryId,
    required this.name,
    required this.colorValue,
    required this.amount,
  });
  final String categoryId;
  final String name;
  final int colorValue;
  final double amount;
}
