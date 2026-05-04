import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../transactions/domain/models/category.dart';
import '../../../transactions/domain/models/transaction.dart';
import 'recent_tile.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.categories,
    required this.onViewAll,
  });

  final List<Transaction> transactions;
  final List<Category> categories;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 4),
            child: Row(
              children: [
                Text(
                  'Recent Transactions',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'View all',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.electricBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...transactions.map((t) => RecentTile(
                transaction: t,
                category: categories
                    .where((c) => c.id == t.categoryId && c.type == t.type)
                    .firstOrNull,
              )),
        ],
      ),
    );
  }
}
