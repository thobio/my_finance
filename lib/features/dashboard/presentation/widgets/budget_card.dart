import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../budget/presentation/providers/budget_providers.dart';

class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key, required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final now = DateTime.now();
    final currentYearMonth = DateFormat('yyyy-MM').format(now);
    final monthsAsync = ref.watch(budgetMonthsProvider);
    final months = monthsAsync.valueOrNull;

    if (months == null) return const SizedBox.shrink();

    final current = months.where((m) => m.yearMonth == currentYearMonth).firstOrNull;
    if (current == null) return const SizedBox.shrink();

    final totalProjected = current.projected.values.fold(0.0, (a, b) => a + b);
    if (totalProjected == 0) return const SizedBox.shrink();

    final totalActual = current.actual.values.fold(0.0, (a, b) => a + b);
    final progress = (totalActual / totalProjected).clamp(0.0, 1.0);
    final isOver = totalActual > totalProjected;
    final progressColor = isOver ? AppColors.danger : AppColors.electricBlue;

    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final monthLabel = DateFormat('MMMM').format(now);

    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pie_chart_outline_rounded,
                    color: AppColors.electricBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Budget · $monthLabel',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'View',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.electricBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right,
                    color: AppColors.electricBlue, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: progressColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(progressColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AmountLabel(
                  label: 'Spent',
                  amount: fmt.format(totalActual),
                  color: progressColor,
                ),
                _AmountLabel(
                  label: 'Budget',
                  amount: fmt.format(totalProjected),
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  alignRight: true,
                ),
              ],
            ),
            if (isOver) ...[
              const SizedBox(height: 6),
              Text(
                'Over budget by ${fmt.format(totalActual - totalProjected)}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.danger),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AmountLabel extends StatelessWidget {
  const _AmountLabel({
    required this.label,
    required this.amount,
    required this.color,
    this.alignRight = false,
  });

  final String label;
  final String amount;
  final Color color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: color),
        ),
        Text(
          amount,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
