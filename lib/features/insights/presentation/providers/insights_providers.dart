import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../features/accounts/presentation/providers/account_providers.dart';
import '../../../../features/bills/presentation/providers/recurrence_providers.dart';
import '../../../../features/dashboard/presentation/providers/dashboard_providers.dart';
import '../../../../features/debts/presentation/providers/debt_providers.dart';
import '../../../../features/goals/domain/models/goal.dart';
import '../../../../features/goals/domain/models/goal_status.dart';
import '../../../../features/goals/domain/models/goal_type.dart';
import '../../../../features/goals/presentation/providers/goal_providers.dart';
import '../../../../features/transactions/domain/models/transaction.dart';
import '../../../../features/transactions/domain/models/transaction_type.dart';
import '../../../../features/transactions/presentation/providers/transaction_providers.dart';
import '../../domain/models/app_insight.dart';
import '../../domain/models/health_pillars.dart';
import '../../domain/models/insight_severity.dart';
import '../../domain/models/insight_type.dart';

// ── Health Score ──────────────────────────────────────────────────────────────

final healthScoreProvider = Provider<HealthPillars>((ref) {
  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month);
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final goals = ref.watch(goalsProvider).valueOrNull ?? [];
  final debts = ref.watch(debtsProvider).valueOrNull ?? [];
  final recurrences = ref.watch(recurrencesProvider).valueOrNull ?? [];
  final accounts = ref.watch(accountsProvider).valueOrNull ?? [];

  if (txns.isEmpty && debts.isEmpty && goals.isEmpty && recurrences.isEmpty && accounts.isEmpty) {
    return const HealthPillars.empty();
  }

  // ── Savings score (0–25) ──────────────────────────────────────────────────
  final summary = MonthlySummary.from(txns, currentMonth);
  final savingsScore = _savingsScore(summary.savingsRate);

  // ── Debt score (0–25) ─────────────────────────────────────────────────────
  final totalMinPayments = debts.fold(0.0, (s, d) => s + d.minimumPayment);
  final income = summary.income;
  final debtScore = _debtScore(totalMinPayments, income);

  // ── Goals score (0–20) ────────────────────────────────────────────────────
  final activeGoals = goals
      .where((g) => g.status == GoalStatus.active && g.type != GoalType.emergencyFund)
      .toList();
  final goalsScore = _goalsScore(activeGoals, now);

  // ── Emergency fund score (0–20) ───────────────────────────────────────────
  final emergencyGoal = goals
      .where((g) => g.type == GoalType.emergencyFund && g.status == GoalStatus.active)
      .firstOrNull;
  final avg3MonthExpense = _avg3MonthExpense(txns, now);
  final emergencyScore = _emergencyScore(emergencyGoal?.currentSaved ?? 0, avg3MonthExpense);

  // ── Bills score (0–10) ────────────────────────────────────────────────────
  final overdueCount = recurrences
      .where((r) => r.isActive && r.nextDueDate.isBefore(now))
      .length;
  final billsScore = _billsScore(overdueCount);

  return HealthPillars(
    savingsScore: savingsScore,
    debtScore: debtScore,
    goalsScore: goalsScore,
    emergencyScore: emergencyScore,
    billsScore: billsScore,
  );
});

// ── Insights ──────────────────────────────────────────────────────────────────

final dismissedInsightIdsProvider = StateProvider<Set<String>>((ref) => {});

final appInsightsProvider = Provider<List<AppInsight>>((ref) {
  final now = DateTime.now();
  final monthKey = DateFormat('yyyy-MM').format(now);
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final goals = ref.watch(goalsProvider).valueOrNull ?? [];
  final debts = ref.watch(debtsProvider).valueOrNull ?? [];
  final recurrences = ref.watch(recurrencesProvider).valueOrNull ?? [];
  final cats = ref.watch(categoriesProvider).valueOrNull ?? [];

  final insights = <AppInsight>[];
  final currentMonth = DateTime(now.year, now.month);
  final prevMonth = DateTime(now.year, now.month - 1);

  // ── Overspending by category ──────────────────────────────────────────────
  final currentSpend = _categorySpendMap(txns, currentMonth);
  final prevSpend = _categorySpendMap(txns, prevMonth);
  for (final entry in currentSpend.entries) {
    final prev = prevSpend[entry.key] ?? 0.0;
    if (prev > 0 && entry.value > prev * 1.5) {
      final catName = cats.where((c) => c.id == entry.key).firstOrNull?.name ?? 'a category';
      insights.add(AppInsight(
        id: 'overspending_${entry.key}_$monthKey',
        type: InsightType.overspending,
        severity: InsightSeverity.warning,
        title: 'Spending surge in $catName',
        body: 'You\'ve spent ${_pct(entry.value, prev)}% more than last month.',
      ));
    }
  }

  // ── Low savings rate ──────────────────────────────────────────────────────
  final summary = MonthlySummary.from(txns, currentMonth);
  if (summary.income > 0 && summary.savingsRate < 10) {
    insights.add(AppInsight(
      id: 'low_savings_$monthKey',
      type: InsightType.lowSavings,
      severity: summary.savingsRate < 0 ? InsightSeverity.critical : InsightSeverity.warning,
      title: 'Low savings rate',
      body: 'Your savings rate is ${summary.savingsRate.toStringAsFixed(0)}% this month. Aim for 20%+.',
    ));
  }

  // ── High debt-to-income ───────────────────────────────────────────────────
  if (summary.income > 0) {
    final minPayments = debts.fold(0.0, (s, d) => s + d.minimumPayment);
    final ratio = minPayments / summary.income;
    if (ratio >= 0.36) {
      insights.add(AppInsight(
        id: 'high_debt_$monthKey',
        type: InsightType.highDebt,
        severity: ratio >= 0.5 ? InsightSeverity.critical : InsightSeverity.warning,
        title: 'High debt payments',
        body: '${(ratio * 100).toStringAsFixed(0)}% of your income goes to minimum debt payments.',
      ));
    }
  }

  // ── Goals behind schedule ─────────────────────────────────────────────────
  for (final goal in goals.where((g) => g.status == GoalStatus.active && g.type != GoalType.emergencyFund)) {
    if (!_isGoalOnTrack(goal, now)) {
      insights.add(AppInsight(
        id: 'goal_behind_${goal.id}',
        type: InsightType.goalBehind,
        severity: InsightSeverity.warning,
        title: '${goal.name} is behind',
        body: 'You\'re not on track to reach your goal by ${DateFormat('MMM y').format(goal.targetDate)}.',
      ));
    }
  }

  // ── Credit card utilization ───────────────────────────────────────────────
  final accounts = ref.watch(accountsProvider).valueOrNull ?? [];
  for (final account in accounts.where((a) => a.creditLimit != null && a.creditLimit! > 0)) {
    final balance = ref.watch(accountBalanceProvider(account));
    final pct = balance / account.creditLimit!;
    if (pct >= 0.7) {
      insights.add(AppInsight(
        id: 'credit_warning_${account.id}',
        type: InsightType.creditWarning,
        severity: pct >= 0.9 ? InsightSeverity.critical : InsightSeverity.warning,
        title: 'High credit utilization on ${account.name}',
        body: '${(pct * 100).toStringAsFixed(0)}% of your credit limit is used. This affects your credit score.',
      ));
    }
  }

  // ── Overdue bills ─────────────────────────────────────────────────────────
  final overdueCount = recurrences.where((r) => r.isActive && r.nextDueDate.isBefore(now)).length;
  if (overdueCount > 0) {
    insights.add(AppInsight(
      id: 'bill_overdue_$monthKey',
      type: InsightType.billOverdue,
      severity: InsightSeverity.critical,
      title: '$overdueCount overdue bill${overdueCount > 1 ? 's' : ''}',
      body: 'You have $overdueCount bill${overdueCount > 1 ? 's' : ''} past due. Review the Bill Calendar.',
    ));
  }

  return insights;
});

final activeInsightsProvider = Provider<List<AppInsight>>((ref) {
  final all = ref.watch(appInsightsProvider);
  final dismissed = ref.watch(dismissedInsightIdsProvider);
  return all.where((i) => !dismissed.contains(i.id)).toList();
});

// ── Spending chart data ───────────────────────────────────────────────────────

class CategorySpendPair {
  const CategorySpendPair({
    required this.categoryId,
    required this.name,
    required this.colorValue,
    required this.current,
    required this.prev,
  });
  final String categoryId;
  final String name;
  final int colorValue;
  final double current;
  final double prev;
}

final spendingChartProvider = Provider<List<CategorySpendPair>>((ref) {
  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month);
  final prevMonth = DateTime(now.year, now.month - 1);
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final cats = ref.watch(categoriesProvider).valueOrNull ?? [];

  final current = _categorySpendMap(txns, currentMonth);
  final prev = _categorySpendMap(txns, prevMonth);

  final allIds = {...current.keys, ...prev.keys};
  final pairs = allIds.map((id) {
    final cat = cats.where((c) => c.id == id).firstOrNull;
    return CategorySpendPair(
      categoryId: id,
      name: cat?.name ?? 'Other',
      colorValue: cat?.colorValue ?? 0xFF607D8B,
      current: current[id] ?? 0.0,
      prev: prev[id] ?? 0.0,
    );
  }).toList()
    ..sort((a, b) => b.current.compareTo(a.current));

  return pairs.take(6).toList();
});

// ── Private helpers ───────────────────────────────────────────────────────────

int _savingsScore(double rate) {
  if (rate >= 30) return 25;
  if (rate >= 20) return 20;
  if (rate >= 10) return 15;
  if (rate >= 5) return 8;
  if (rate >= 0) return 4;
  return 0;
}

int _debtScore(double totalMinPayments, double income) {
  if (totalMinPayments == 0) return 25;
  if (income <= 0) return 10;
  final ratio = totalMinPayments / income;
  if (ratio < 0.20) return 20;
  if (ratio < 0.36) return 15;
  if (ratio < 0.50) return 8;
  return 3;
}

int _goalsScore(List<Goal> goals, DateTime now) {
  if (goals.isEmpty) return 10;
  final onTrack = goals.where((g) => _isGoalOnTrack(g, now)).length;
  return (onTrack / goals.length * 20).round();
}

bool _isGoalOnTrack(Goal goal, DateTime now) {
  final total = goal.targetDate.difference(goal.startDate).inDays;
  if (total <= 0) return true;
  final elapsed = now.difference(goal.startDate).inDays.clamp(0, total);
  final expectedFraction = elapsed / total;
  final actualFraction = goal.targetAmount > 0
      ? goal.currentSaved / goal.targetAmount
      : 0.0;
  return actualFraction >= expectedFraction - 0.05;
}

double _avg3MonthExpense(List<Transaction> txns, DateTime now) {
  double total = 0.0;
  for (int i = 1; i <= 3; i++) {
    final month = DateTime(now.year, now.month - i);
    total += txns
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.year == month.year &&
            t.date.month == month.month)
        .fold(0.0, (s, t) => s + t.amount);
  }
  return total / 3;
}

int _emergencyScore(double saved, double monthlyExpense) {
  if (monthlyExpense <= 0) return saved > 0 ? 10 : 0;
  final months = saved / monthlyExpense;
  if (months >= 6) return 20;
  if (months >= 3) return 15;
  if (months >= 1) return 10;
  if (saved > 0) return 5;
  return 0;
}

int _billsScore(int overdueCount) {
  if (overdueCount == 0) return 10;
  if (overdueCount == 1) return 6;
  if (overdueCount == 2) return 3;
  return 0;
}

Map<String, double> _categorySpendMap(List<Transaction> txns, DateTime month) {
  final map = <String, double>{};
  for (final t in txns) {
    if (t.type != TransactionType.expense) continue;
    if (t.date.year != month.year || t.date.month != month.month) continue;
    map[t.categoryId] = (map[t.categoryId] ?? 0.0) + t.amount;
  }
  return map;
}

String _pct(double current, double prev) =>
    prev > 0 ? ((current - prev) / prev * 100).toStringAsFixed(0) : '∞';
