import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/transaction_type.dart';
import 'transaction_type_chip.dart';

class TransactionTypeToggle extends StatelessWidget {
  const TransactionTypeToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TransactionType value;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TransactionTypeChip(
          label: 'Expense',
          selected: value == TransactionType.expense,
          color: AppColors.danger,
          onTap: () => onChanged(TransactionType.expense),
        ),
        const SizedBox(width: 8),
        TransactionTypeChip(
          label: 'Income',
          selected: value == TransactionType.income,
          color: AppColors.success,
          onTap: () => onChanged(TransactionType.income),
        ),
      ],
    );
  }
}
