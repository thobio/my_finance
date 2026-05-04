import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/budget_month.dart';
import '../../domain/models/year_type.dart';
import 'budget_heatmap_cell.dart';
import 'budget_heatmap_legend.dart';

class BudgetHeatmapSection extends StatelessWidget {
  const BudgetHeatmapSection({
    super.key,
    required this.budget,
    required this.months,
    required this.year,
    required this.yearType,
  });

  final Budget budget;
  final List<BudgetMonth> months;
  final int year;
  final YearType yearType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthsMap = {for (final m in months) m.yearMonth: m};

    final orderedMonths = List.generate(12, (i) {
      final monthIndex =
          yearType == YearType.financial ? ((i + 3) % 12) + 1 : i + 1;
      final yearForMonth = yearType == YearType.financial
          ? (monthIndex >= 4 ? year : year + 1)
          : year;
      final key = '$yearForMonth-${monthIndex.toString().padLeft(2, '0')}';
      return (key: key, monthIndex: monthIndex, year: yearForMonth);
    });

    final monthlyBudget =
        budget.monthlyAllocations.values.fold(0.0, (s, v) => s + v) +
            budget.fixedObligations.values.fold(0.0, (s, v) => s + v);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Heatmap',
          style: AppTextStyles.titleSmall
              .copyWith(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.3,
          ),
          itemCount: 12,
          itemBuilder: (context, i) {
            final info = orderedMonths[i];
            final month = monthsMap[info.key];
            final actual =
                month?.actual.values.fold(0.0, (s, v) => s + v) ?? 0.0;
            final ratio = monthlyBudget > 0
                ? (actual / monthlyBudget).clamp(0.0, 1.5)
                : 0.0;
            final isCurrentMonth = DateTime.now().year == info.year &&
                DateTime.now().month == info.monthIndex;
            return BudgetHeatmapCell(
              monthIndex: info.monthIndex,
              ratio: ratio,
              hasData: month != null,
              isCurrent: isCurrentMonth,
            );
          },
        ),
        const SizedBox(height: 8),
        const BudgetHeatmapLegend(),
      ],
    );
  }
}
