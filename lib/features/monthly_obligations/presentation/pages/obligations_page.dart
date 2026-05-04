import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../domain/models/monthly_obligation.dart';
import '../../domain/models/obligation_summary.dart';
import '../providers/monthly_obligation_providers.dart';
import '../widgets/add_edit_obligation_sheet.dart';
import '../widgets/obligation_tile.dart';

class ObligationsPage extends ConsumerWidget {
  const ObligationsPage({super.key});

  String _fmt(double v) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(v);

  String _monthLabel(int year, int month) {
    final date = DateTime(year, month);
    return DateFormat('MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final year = ref.watch(selectedObligationYearProvider);
    final month = ref.watch(selectedObligationMonthProvider);
    final params = (year, month);

    final obligationsAsync = ref.watch(obligationsProvider(params));
    final summary = ref.watch(obligationSummaryProvider(params));

    // Previous month for carry-over detection
    final prevMonth = month == 1 ? 12 : month - 1;
    final prevYear = month == 1 ? year - 1 : year;
    final prevObligations =
        ref.watch(obligationsProvider((prevYear, prevMonth))).valueOrNull ?? [];
    final unpaidFromPrev = prevObligations.where((o) => !o.isPaid).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  'Monthly Obligations',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: theme.colorScheme.onSurface),
                ),
              ),
            ),

            // ── Month navigator ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _prevMonth(ref, year, month),
                    ),
                    Text(
                      _monthLabel(year, month),
                      style: AppTextStyles.titleMedium
                          .copyWith(color: theme.colorScheme.onSurface),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _nextMonth(ref, year, month),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Carry-over banner ───────────────────────────────────────
                  if (unpaidFromPrev.isNotEmpty)
                    _CarryOverBanner(
                      unpaidCount: unpaidFromPrev.length,
                      unpaidAmount: unpaidFromPrev.fold(
                          0.0, (s, o) => s + o.amount),
                      isDark: isDark,
                      onCarryOver: () => _carryOver(
                          ref, unpaidFromPrev, year, month),
                      formatAmount: _fmt,
                    ),

                  const SizedBox(height: 8),

                  // ── Summary card ─────────────────────────────────────────────
                  _SummaryCard(
                    summary: summary,
                    isDark: isDark,
                    formatAmount: _fmt,
                  ),

                  const SizedBox(height: 20),

                  // ── Obligation list ──────────────────────────────────────────
                  obligationsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (obligations) => obligations.isEmpty
                        ? _EmptyState(isDark: isDark)
                        : _ObligationList(
                            obligations: obligations,
                            isDark: isDark,
                          ),
                  ),

                  // ── Pay plan ─────────────────────────────────────────────────
                  if (summary.payPlan.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _PayPlanSection(
                      summary: summary,
                      isDark: isDark,
                      formatAmount: _fmt,
                    ),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddEditObligationSheet.show(
          context,
          initialYear: year,
          initialMonth: month,
        ),
        tooltip: 'Add obligation',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _prevMonth(WidgetRef ref, int year, int month) {
    if (month == 1) {
      ref.read(selectedObligationYearProvider.notifier).state = year - 1;
      ref.read(selectedObligationMonthProvider.notifier).state = 12;
    } else {
      ref.read(selectedObligationMonthProvider.notifier).state = month - 1;
    }
  }

  void _nextMonth(WidgetRef ref, int year, int month) {
    if (month == 12) {
      ref.read(selectedObligationYearProvider.notifier).state = year + 1;
      ref.read(selectedObligationMonthProvider.notifier).state = 1;
    } else {
      ref.read(selectedObligationMonthProvider.notifier).state = month + 1;
    }
  }

  Future<void> _carryOver(
    WidgetRef ref,
    List<MonthlyObligation> unpaid,
    int year,
    int month,
  ) async {
    await ref.read(obligationControllerProvider.notifier).carryOver(
          unpaidObligations: unpaid,
          toYear: year,
          toMonth: month,
        );
  }
}

// ── Carry-over banner ─────────────────────────────────────────────────────────

class _CarryOverBanner extends StatelessWidget {
  const _CarryOverBanner({
    required this.unpaidCount,
    required this.unpaidAmount,
    required this.isDark,
    required this.onCarryOver,
    required this.formatAmount,
  });

  final int unpaidCount;
  final double unpaidAmount;
  final bool isDark;
  final VoidCallback onCarryOver;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$unpaidCount unpaid item${unpaidCount > 1 ? 's' : ''} '
              '(${formatAmount(unpaidAmount)}) from last month',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onCarryOver,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warning,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Carry over',
                style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.summary,
    required this.isDark,
    required this.formatAmount,
  });

  final ObligationSummary summary;
  final bool isDark;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final surplusColor =
        summary.surplus >= 0 ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _statBox(
                theme,
                label: 'Available Balance',
                value: formatAmount(summary.totalIncome),
                color: AppColors.success,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _statBox(
                theme,
                label: 'Total Obligations',
                value: formatAmount(summary.totalObligations),
                color: AppColors.danger,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: surplusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  summary.surplus >= 0
                      ? 'Surplus after all obligations'
                      : 'Deficit — income falls short',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: surplusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formatAmount(summary.surplus.abs()),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: surplusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (summary.paidAmount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paid so far',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                Text(
                  '${formatAmount(summary.paidAmount)} / ${formatAmount(summary.totalObligations)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statBox(
    ThemeData theme, {
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) =>
      Expanded(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      );
}

// ── Obligation list ───────────────────────────────────────────────────────────

class _ObligationList extends StatelessWidget {
  const _ObligationList({
    required this.obligations,
    required this.isDark,
  });

  final List<MonthlyObligation> obligations;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unpaid = obligations.where((o) => !o.isPaid).toList();
    final paid = obligations.where((o) => o.isPaid).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (unpaid.isNotEmpty) ...[
          Text(
            'To Pay (${unpaid.length})',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...unpaid.map((o) =>
              ObligationTile(obligation: o, isDark: isDark)),
        ],
        if (paid.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Paid (${paid.length})',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 8),
          ...paid.map((o) =>
              ObligationTile(obligation: o, isDark: isDark)),
        ],
      ],
    );
  }
}

// ── Pay plan section ──────────────────────────────────────────────────────────

class _PayPlanSection extends StatelessWidget {
  const _PayPlanSection({
    required this.summary,
    required this.isDark,
    required this.formatAmount,
  });

  final ObligationSummary summary;
  final bool isDark;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final steps = summary.payPlan;

    if (steps.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.route_outlined,
                  color: AppColors.electricBlue, size: 18),
              const SizedBox(width: 8),
              Text(
                'Pay Plan',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'How to clear your unpaid obligations from your account balance',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _startRow(theme, isDark),
          ...steps.asMap().entries.map(
                (e) => _stepRow(theme, e.key, e.value, steps.length, isDark),
              ),
        ],
      ),
    );
  }

  Widget _startRow(ThemeData theme, bool isDark) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            _dot(AppColors.electricBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Account balance: ${formatAmount(summary.totalIncome)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.electricBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _stepRow(
    ThemeData theme,
    int index,
    ObligationPayStep step,
    int total,
    bool isDark,
  ) {
    final color = step.canAfford ? AppColors.success : AppColors.danger;
    final isLast = index == total - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 1.5,
                height: 14,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              _dot(color),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 8, bottom: isLast ? 0 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          step.obligation.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '− ${formatAmount(step.obligation.amount)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.canAfford
                        ? 'Balance after: ${formatAmount(step.balanceAfter)}'
                        : 'Short by ${formatAmount(step.balanceAfter.abs())} — income insufficient',
                    style: theme.textTheme.bodySmall?.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.playlist_add_check_outlined,
                size: 56, color: secondary),
            const SizedBox(height: 16),
            Text('No obligations this month',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: secondary)),
            const SizedBox(height: 6),
            Text(
              'Tap + to add car insurance, friend loans\nor any irregular payment you need to make',
              style: theme.textTheme.bodySmall?.copyWith(color: secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
