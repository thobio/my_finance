import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_text_styles.dart';

class BudgetStatBox extends StatelessWidget {
  const BudgetStatBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${NumberFormat('#,##,##0').format(value)}',
              style: AppTextStyles.titleSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
