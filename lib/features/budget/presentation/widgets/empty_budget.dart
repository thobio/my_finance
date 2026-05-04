import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/year_type.dart';

class EmptyBudget extends StatelessWidget {
  const EmptyBudget({
    super.key,
    required this.year,
    required this.yearType,
  });

  final int year;
  final YearType yearType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = yearType == YearType.financial
        ? 'FY $year-${(year + 1).toString().substring(2)}'
        : year.toString();

    return SizedBox(
      height: 340,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 56,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 16),
            Text(
              'No budget for $label',
              style: AppTextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the edit button to set up your budget',
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
