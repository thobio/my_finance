import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../transactions/domain/models/category.dart';
import '../../../transactions/domain/models/transaction.dart';
import '../../../transactions/domain/models/transaction_type.dart';

class RecentTile extends StatelessWidget {
  const RecentTile({
    super.key,
    required this.transaction,
    required this.category,
  });

  final Transaction transaction;
  final Category? category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.success : AppColors.danger;
    final rupees = transaction.amount;
    final color = category != null
        ? Color(category!.colorValue)
        : AppColors.darkTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.receipt_long_outlined, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: theme.colorScheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  category?.name ?? 'Uncategorised',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}₹${NumberFormat('#,##,##0').format(rupees)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: amountColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
