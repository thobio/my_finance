import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../transactions/domain/models/category.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/add_edit_transaction_sheet.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_summary_grid.dart';
import '../widgets/empty_dashboard.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/savings_rate_chart.dart';
import '../widgets/income_chart.dart';
import '../widgets/monthly_spending_chart.dart';
import '../widgets/net_worth_card.dart';
import '../widgets/health_score_card.dart';
import '../widgets/budget_card.dart';
import '../widgets/upcoming_bills_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authUserProvider).valueOrNull;
    final txnAsync = ref.watch(transactionsProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final summary = ref.watch(monthlySummaryProvider);
    final rateSeries = ref.watch(savingsRateSeriesProvider);
    final incomeSeries = ref.watch(incomeSeriesProvider);
    final topCats = ref.watch(topCategoriesProvider);
    final recent = ref.watch(recentTransactionsProvider);
    final cats = ref.watch(categoriesProvider).valueOrNull ?? <Category>[];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: txnAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (_) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DashboardHeader(
                  user: user,
                  selectedMonth: selectedMonth,
                  onPrevMonth: () =>
                      ref.read(selectedMonthProvider.notifier).state = DateTime(
                    selectedMonth.year,
                    selectedMonth.month - 1,
                  ),
                  onNextMonth: () =>
                      ref.read(selectedMonthProvider.notifier).state = DateTime(
                    selectedMonth.year,
                    selectedMonth.month + 1,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const HealthScoreCard(),
                    const SizedBox(height: 16),
                    DashboardSummaryGrid(summary: summary),
                    const SizedBox(height: 16),
                    IncomeChart(series: incomeSeries),
                    const SizedBox(height: 16),
                    SavingsRateChart(series: rateSeries),
                    const SizedBox(height: 16),
                    if (topCats.isNotEmpty) ...[
                      MonthlySpendingChart(categories: topCats),
                      const SizedBox(height: 16),
                    ],
                    const NetWorthCard(),
                    const SizedBox(height: 16),
                    BudgetCard(onViewAll: () => context.go('/budget')),
                    const SizedBox(height: 16),
                    UpcomingBillsCard(onViewAll: () => context.go('/bills')),
                    const SizedBox(height: 16),
                    if (recent.isNotEmpty)
                      RecentTransactions(
                        transactions: recent,
                        categories: cats,
                        onViewAll: () => context.go('/transactions'),
                      ),
                    if (recent.isEmpty && topCats.isEmpty)
                      EmptyDashboard(onAdd: () => _openAdd(context)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context),
        tooltip: 'Add transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddEditTransactionSheet(),
    );
  }
}
