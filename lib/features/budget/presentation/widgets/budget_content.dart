import 'package:flutter/material.dart';

import '../../domain/models/budget.dart';
import '../../domain/models/budget_month.dart';
import '../../domain/models/year_type.dart';
import 'allocation_section.dart';
import 'budget_heatmap_section.dart';
import 'budget_summary_card.dart';
import 'empty_budget.dart';
import 'fixed_obligations_section.dart';

class BudgetContent extends StatelessWidget {
  const BudgetContent({
    super.key,
    required this.budget,
    required this.months,
    required this.year,
    required this.yearType,
  });

  final Budget? budget;
  final List<BudgetMonth> months;
  final int year;
  final YearType yearType;

  @override
  Widget build(BuildContext context) {
    if (budget == null) {
      return EmptyBudget(year: year, yearType: yearType);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        BudgetSummaryCard(budget: budget!, months: months),
        const SizedBox(height: 20),
        BudgetHeatmapSection(
          budget: budget!,
          months: months,
          year: year,
          yearType: yearType,
        ),
        const SizedBox(height: 20),
        if (budget!.fixedObligations.isNotEmpty) ...[
          FixedObligationsSection(budget: budget!),
          const SizedBox(height: 20),
        ],
        if (budget!.monthlyAllocations.isNotEmpty)
          AllocationSection(budget: budget!),
      ],
    );
  }
}
