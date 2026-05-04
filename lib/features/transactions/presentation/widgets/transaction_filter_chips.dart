import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/transaction_type.dart';
import 'transaction_filter_chip.dart';

class TransactionFilterChips extends StatelessWidget {
  const TransactionFilterChips({
    super.key,
    required this.typeFilter,
    required this.onChanged,
  });

  final TransactionType? typeFilter;
  final ValueChanged<TransactionType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TransactionFilterChip(
          label: 'All',
          selected: typeFilter == null,
          onTap: () => onChanged(null),
        ),
        const SizedBox(width: 8),
        TransactionFilterChip(
          label: 'Expenses',
          selected: typeFilter == TransactionType.expense,
          color: AppColors.danger,
          onTap: () => onChanged(
            typeFilter == TransactionType.expense
                ? null
                : TransactionType.expense,
          ),
        ),
        const SizedBox(width: 8),
        TransactionFilterChip(
          label: 'Income',
          selected: typeFilter == TransactionType.income,
          color: AppColors.success,
          onTap: () => onChanged(
            typeFilter == TransactionType.income
                ? null
                : TransactionType.income,
          ),
        ),
      ],
    );
  }
}
