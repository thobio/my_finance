import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/budget.dart';
import 'allocation_row.dart';

class AllocationSection extends StatelessWidget {
  const AllocationSection({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = budget.monthlyAllocations.values.fold(0.0, (s, v) => s + v);
    final sorted = budget.monthlyAllocations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Monthly Allocations',
              style: AppTextStyles.titleSmall
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            const Spacer(),
            Text(
              '₹${NumberFormat('#,##,##0').format(total)}/mo total',
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...sorted.map((e) => AllocationRow(
              name: e.key,
              amount: e.value,
              total: total,
            )),
      ],
    );
  }
}
