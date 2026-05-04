import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../providers/dashboard_providers.dart';

class CategorySpendRow extends StatelessWidget {
  const CategorySpendRow({
    super.key,
    required this.spend,
    required this.maxAmount,
  });

  final CategorySpend spend;
  final double maxAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(spend.colorValue);
    final fraction = maxAmount > 0 ? spend.amount / maxAmount : 0.0;
    final rupees = spend.amount;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  spend.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '₹${NumberFormat('#,##,##0').format(rupees)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 4,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
