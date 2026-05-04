import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_type.dart';
import 'add_edit_debt_sheet.dart';

class DebtTile extends StatelessWidget {
  const DebtTile({super.key, required this.debt, required this.isDark});

  final Debt debt;
  final bool isDark;

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  IconData get _icon => switch (debt.type) {
        DebtType.loan => Icons.account_balance_outlined,
        DebtType.creditCard => Icons.credit_card_outlined,
        DebtType.bnpl => Icons.shopping_cart_outlined,
      };

  Color get _color => switch (debt.type) {
        DebtType.loan => AppColors.electricBlue,
        DebtType.creditCard => const Color(0xFFFF6B6B),
        DebtType.bnpl => AppColors.gold,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;

    return GestureDetector(
      onTap: () => AddEditDebtSheet.show(context, existing: debt),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: _color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    debt.label,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${debt.type.label} · ${debt.interestRatePercent.toStringAsFixed(1)}% p.a. · Due day ${debt.dueDay}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _fmt(debt.outstanding),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger,
                  ),
                ),
                Text(
                  'Min ${_fmt(debt.minimumPayment)}/mo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
