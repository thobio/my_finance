import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/budget_month.dart';
import 'budget_stat_box.dart';

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    super.key,
    required this.budget,
    required this.months,
  });

  final Budget budget;
  final List<BudgetMonth> months;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalActual = months.fold<double>(
      0.0,
      (sum, m) => sum + m.actual.values.fold(0.0, (s, v) => s + v),
    );
    final totalProjected = budget.totalProjectedIncome;
    final spent = totalActual;
    final remaining = (totalProjected - spent).clamp(0.0, totalProjected);
    final spendRatio =
        totalProjected > 0 ? (spent / totalProjected).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Annual Overview',
            style: AppTextStyles.titleSmall
                .copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              BudgetStatBox(
                label: 'Income',
                value: totalProjected,
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              BudgetStatBox(
                label: 'Spent',
                value: spent,
                color: AppColors.danger,
              ),
              const SizedBox(width: 12),
              BudgetStatBox(
                label: 'Left',
                value: remaining,
                color: AppColors.electricBlue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: spendRatio,
              minHeight: 6,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(
                spendRatio > 0.9 ? AppColors.danger : AppColors.electricBlue,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(spendRatio * 100).toStringAsFixed(1)}% of income spent',
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
