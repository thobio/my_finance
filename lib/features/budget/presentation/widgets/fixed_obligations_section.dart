import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/budget.dart';

class FixedObligationsSection extends StatelessWidget {
  const FixedObligationsSection({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = budget.fixedObligations.values.fold(0.0, (s, v) => s + v);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Fixed Obligations',
              style: AppTextStyles.titleSmall
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            const Spacer(),
            Text(
              '₹${NumberFormat('#,##,##0').format(total)}/mo',
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: budget.fixedObligations.entries.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Text(
                '${e.key}  ₹${NumberFormat('#,##,##0').format(e.value)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
