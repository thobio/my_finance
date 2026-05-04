import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_type.dart';
import '../providers/debt_providers.dart';
import '../widgets/add_edit_debt_sheet.dart';
import '../widgets/credit_utilization_card.dart';
import '../widgets/debt_tile.dart';
import '../widgets/payoff_planner_sheet.dart';

class DebtsPage extends ConsumerWidget {
  const DebtsPage({super.key});

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final debtsAsync = ref.watch(debtsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
        actions: [
          debtsAsync.whenOrNull(
            data: (debts) => debts.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.calculate_outlined),
                    tooltip: 'Payoff Planner',
                    onPressed: () => PayoffPlannerSheet.show(
                      context,
                      debts: debts,
                    ),
                  )
                : null,
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: debtsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (debts) => _buildBody(context, debts, isDark),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddEditDebtSheet.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Debt> debts, bool isDark) {
    final theme = Theme.of(context);

    if (debts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.credit_card_off_outlined,
              size: 64,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No debts tracked',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add loans, credit cards or BNPL to plan your payoff',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final totalOutstanding = debts.fold(0.0, (s, d) => s + d.outstanding);
    final totalMinPayment = debts.fold(0.0, (s, d) => s + d.minimumPayment);
    final creditCards =
        debts.where((d) => d.type == DebtType.creditCard).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary card
        _SummaryCard(
          totalOutstanding: totalOutstanding,
          totalMinPayment: totalMinPayment,
          debtCount: debts.length,
          isDark: isDark,
          formatAmount: _fmt,
        ),
        const SizedBox(height: 16),

        // Credit utilization (only if any credit cards with limit set)
        CreditUtilizationCard(debts: creditCards, isDark: isDark),

        // Planner prompt
        _PlannerBanner(
          debts: debts,
          isDark: isDark,
        ),
        const SizedBox(height: 16),

        // Debt list
        Text(
          'Your Debts',
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...debts.map((d) => DebtTile(debt: d, isDark: isDark)),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ── Summary Card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totalOutstanding,
    required this.totalMinPayment,
    required this.debtCount,
    required this.isDark,
    required this.formatAmount,
  });

  final double totalOutstanding;
  final double totalMinPayment;
  final int debtCount;
  final bool isDark;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Text(
            'Total Outstanding',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatAmount(totalOutstanding),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.danger,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat(theme, '$debtCount', 'Debts'),
              _divider(),
              _stat(theme, formatAmount(totalMinPayment), 'Min / mo'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(ThemeData theme, String value, String label) => Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      );

  Widget _divider() => Container(
        height: 32,
        width: 1,
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      );
}

// ── Planner Banner ────────────────────────────────────────────────────────────

class _PlannerBanner extends StatelessWidget {
  const _PlannerBanner({required this.debts, required this.isDark});

  final List<Debt> debts;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => PayoffPlannerSheet.show(context, debts: debts),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.electricBlue.withValues(alpha: 0.15),
              AppColors.electricBlue.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.electricBlue.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calculate_outlined,
                color: AppColors.electricBlue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payoff Planner',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.electricBlue,
                    ),
                  ),
                  Text(
                    'Compare avalanche vs snowball strategies',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.electricBlue.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.electricBlue, size: 20),
          ],
        ),
      ),
    );
  }
}
