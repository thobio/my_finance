import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/distribution_line.dart';

class DistributionLineTile extends StatelessWidget {
  const DistributionLineTile({
    super.key,
    required this.line,
    required this.formatAmount,
    required this.total,
  });

  final DistributionLine line;
  final String Function(double) formatAmount;
  final double total;

  Color _typeColor(DistributionLineType t) => switch (t) {
        DistributionLineType.fixedObligation => AppColors.danger,
        DistributionLineType.goalContribution => AppColors.gold,
        DistributionLineType.categoryAllocation => AppColors.electricBlue,
      };

  IconData _typeIcon(DistributionLineType t) => switch (t) {
        DistributionLineType.fixedObligation => Icons.lock_outline_rounded,
        DistributionLineType.goalContribution => Icons.flag_outlined,
        DistributionLineType.categoryAllocation => Icons.category_outlined,
      };

  String _typeLabel(DistributionLineType t) => switch (t) {
        DistributionLineType.fixedObligation => 'Obligation',
        DistributionLineType.goalContribution => 'Goal',
        DistributionLineType.categoryAllocation => 'Category',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _typeColor(line.type);
    final pct = total > 0 ? line.amount / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_typeIcon(line.type), color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(line.label,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    Text(formatAmount(line.amount),
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: pct.clamp(0.0, 1.0),
                          backgroundColor: color.withValues(alpha: 0.1),
                          color: color,
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(pct * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _typeLabel(line.type),
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: color, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
