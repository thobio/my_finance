import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/dashboard_providers.dart';
import 'summary_card.dart';

class DashboardSummaryGrid extends StatelessWidget {
  const DashboardSummaryGrid({super.key, required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: 'Income',
                amount: summary.income,
                color: AppColors.success,
                icon: Icons.arrow_downward_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                label: 'Expenses',
                amount: summary.expense,
                color: AppColors.danger,
                icon: Icons.arrow_upward_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: 'Net Savings',
                amount: summary.net,
                color: summary.net >= 0
                    ? AppColors.electricBlue
                    : AppColors.danger,
                icon: summary.net >= 0
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SavingsRateCard(rate: summary.savingsRate),
            ),
          ],
        ),
      ],
    );
  }
}
