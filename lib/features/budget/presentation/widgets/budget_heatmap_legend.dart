import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BudgetHeatmapLegend extends StatelessWidget {
  const BudgetHeatmapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        ...[
          (AppColors.success.withValues(alpha: 0.7), '≤50%'),
          (AppColors.warning.withValues(alpha: 0.8), '50–100%'),
          (AppColors.danger.withValues(alpha: 0.85), '>100%'),
        ].map((e) => Row(children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: e.$1,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                e.$2,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 10),
            ])),
      ],
    );
  }
}
