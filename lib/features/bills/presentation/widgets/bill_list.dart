import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/recurrence.dart';
import '../providers/recurrence_providers.dart';
import 'add_edit_recurrence_sheet.dart';
import 'bill_tile.dart';

class BillList extends ConsumerWidget {
  const BillList({
    super.key,
    required this.bills,
    required this.title,
    required this.isDark,
  });

  final List<Recurrence> bills;
  final String title;
  final bool isDark;

  Future<void> _handleMarkPaid(
      BuildContext context, WidgetRef ref, Recurrence bill) async {
    if (bill.amount != 0) {
      await ref.read(recurrenceControllerProvider.notifier).markPaid(bill.id);
      return;
    }

    // Variable amount — ask for the actual amount paid
    final ctrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Mark "${bill.label}" as paid'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Amount paid (₹)',
            prefixText: '₹ ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Mark paid'),
          ),
        ],
      ),
    );
    ctrl.dispose();

    if (confirmed == true && context.mounted) {
      await ref.read(recurrenceControllerProvider.notifier).markPaid(bill.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (bills.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 48,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'No bills due',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: bills.length,
            itemBuilder: (_, i) => BillTile(
              recurrence: bills[i],
              isDark: isDark,
              onPaid: () => _handleMarkPaid(context, ref, bills[i]),
              onEdit: () =>
                  AddEditRecurrenceSheet.show(context, existing: bills[i]),
            ),
          ),
        ),
      ],
    );
  }
}
