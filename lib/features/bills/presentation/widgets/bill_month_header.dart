import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';

class BillMonthHeader extends StatelessWidget {
  const BillMonthHeader({
    super.key,
    required this.month,
    required this.total,
    required this.isDark,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final double total;
  final bool isDark;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onPrev,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(month),
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${fmt.format(total)} due',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.danger),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
