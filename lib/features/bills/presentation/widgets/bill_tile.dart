import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/recurrence.dart';
import '../../domain/models/recurrence_frequency.dart';

class BillTile extends StatelessWidget {
  const BillTile({
    super.key,
    required this.recurrence,
    required this.isDark,
    required this.onPaid,
    required this.onEdit,
  });

  final Recurrence recurrence;
  final bool isDark;
  final VoidCallback onPaid;
  final VoidCallback onEdit;

  String _formatAmount(double value) => value == 0
      ? 'Variable'
      : NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  bool get _isOverdue => recurrence.nextDueDate.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurfaceVariant;
    final overdue = _isOverdue;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: overdue
            ? Border.all(color: AppColors.danger.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (overdue ? AppColors.danger : AppColors.electricBlue)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: overdue ? AppColors.danger : AppColors.electricBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recurrence.label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${recurrence.frequency.label} · Due ${DateFormat('d MMM').format(recurrence.nextDueDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: overdue
                        ? AppColors.danger
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatAmount(recurrence.amount),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: overdue ? AppColors.danger : null,
            ),
          ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 18),
            onSelected: (v) {
              if (v == 'paid') onPaid();
              if (v == 'edit') onEdit();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'paid', child: Text('Mark as paid')),
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
            ],
          ),
        ],
      ),
    );
  }
}
