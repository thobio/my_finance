import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BudgetHeatmapCell extends StatelessWidget {
  const BudgetHeatmapCell({
    super.key,
    required this.monthIndex,
    required this.ratio,
    required this.hasData,
    required this.isCurrent,
  });

  final int monthIndex;
  final double ratio;
  final bool hasData;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _heatColor(ratio, hasData);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: isCurrent
            ? Border.all(color: AppColors.electricBlue, width: 2)
            : Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('MMM').format(DateTime(2000, monthIndex)),
            style: AppTextStyles.bodySmall.copyWith(
              color: hasData
                  ? Colors.white.withValues(alpha: 0.9)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          if (hasData) ...[
            const SizedBox(height: 2),
            Text(
              '${(ratio * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _heatColor(double ratio, bool hasData) {
    if (!hasData) return Colors.grey.withValues(alpha: 0.08);
    if (ratio <= 0.5) {
      return AppColors.success.withValues(alpha: 0.6 + ratio * 0.4);
    }
    if (ratio <= 0.8) return AppColors.warning.withValues(alpha: 0.7);
    if (ratio <= 1.0) return AppColors.warning.withValues(alpha: 0.9);
    return AppColors.danger.withValues(alpha: 0.85);
  }
}
