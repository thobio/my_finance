import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/monthly_obligation.dart';
import '../../domain/models/obligation_priority.dart';
import '../providers/monthly_obligation_providers.dart';
import 'add_edit_obligation_sheet.dart';

class ObligationTile extends ConsumerWidget {
  const ObligationTile({
    super.key,
    required this.obligation,
    required this.isDark,
  });

  final MonthlyObligation obligation;
  final bool isDark;

  String _fmt(double v) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(v);

  Color _priorityColor(ObligationPriority p) => switch (p) {
        ObligationPriority.high => AppColors.danger,
        ObligationPriority.medium => AppColors.warning,
        ObligationPriority.low => AppColors.success,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final surface =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final priorityColor = _priorityColor(obligation.priority);

    return GestureDetector(
      onTap: () =>
          AddEditObligationSheet.show(context, existing: obligation),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: obligation.isPaid
              ? Border.all(
                  color: AppColors.success.withValues(alpha: 0.4),
                )
              : null,
        ),
        child: Row(
          children: [
            // Priority indicator bar
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: obligation.isPaid
                    ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                    : priorityColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obligation.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: obligation.isPaid
                          ? TextDecoration.lineThrough
                          : null,
                      color: obligation.isPaid
                          ? (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${obligation.priority.label} priority · Due day ${obligation.dueDay}',
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

            // Amount
            Text(
              _fmt(obligation.amount),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: obligation.isPaid
                    ? AppColors.success
                    : theme.colorScheme.onSurface,
                decoration:
                    obligation.isPaid ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(width: 8),

            // Paid checkbox
            GestureDetector(
              onTap: () => ref
                  .read(obligationControllerProvider.notifier)
                  .togglePaid(obligation),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: obligation.isPaid
                      ? AppColors.success
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: obligation.isPaid
                        ? AppColors.success
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: 1.5,
                  ),
                ),
                child: obligation.isPaid
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
