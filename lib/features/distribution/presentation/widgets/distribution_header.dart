import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DistributionHeader extends StatelessWidget {
  const DistributionHeader({
    super.key,
    required this.income,
    required this.formatAmount,
  });

  final double income;
  final String Function(double) formatAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_rounded,
              color: AppColors.electricBlue, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Income Distribution',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(formatAmount(income),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }
}
