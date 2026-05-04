import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmptyDashboard extends StatelessWidget {
  const EmptyDashboard({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 260,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 56,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 16),
            Text(
              'No data for this month',
              style: AppTextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onAdd,
              child: Text(
                'Add a transaction',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.electricBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
