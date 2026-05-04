import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AllocationRow extends StatelessWidget {
  const AllocationRow({
    super.key,
    required this.name,
    required this.amount,
    required this.total,
  });

  final String name;
  final double amount;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio =
        total > 0 ? (amount / total).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: theme.colorScheme.onSurface),
                ),
              ),
              Text(
                '₹${NumberFormat('#,##,##0').format(amount)}/mo',
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 4,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.08),
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.electricBlue),
            ),
          ),
        ],
      ),
    );
  }
}
