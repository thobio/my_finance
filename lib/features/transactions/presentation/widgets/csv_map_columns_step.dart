import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../accounts/presentation/providers/account_providers.dart';
import 'csv_column_dropdown.dart';

class CsvMapColumnsStep extends ConsumerWidget {
  const CsvMapColumnsStep({
    super.key,
    required this.headers,
    required this.dateCol,
    required this.dateFormat,
    required this.descCol,
    required this.amountCol,
    required this.debitCol,
    required this.creditCol,
    required this.useSeparateDebitCredit,
    required this.accountId,
    required this.onDateCol,
    required this.onDateFormat,
    required this.onDescCol,
    required this.onAmountCol,
    required this.onDebitCol,
    required this.onCreditCol,
    required this.onSeparateToggle,
    required this.onAccountId,
    required this.onImport,
  });

  final List<String> headers;
  final String? dateCol;
  final String? dateFormat;
  final String? descCol;
  final String? amountCol;
  final String? debitCol;
  final String? creditCol;
  final bool useSeparateDebitCredit;
  final String? accountId;
  final ValueChanged<String?> onDateCol;
  final ValueChanged<String?> onDateFormat;
  final ValueChanged<String?> onDescCol;
  final ValueChanged<String?> onAmountCol;
  final ValueChanged<String?> onDebitCol;
  final ValueChanged<String?> onCreditCol;
  final ValueChanged<bool> onSeparateToggle;
  final ValueChanged<String?> onAccountId;
  final VoidCallback onImport;

  bool get _canImport =>
      dateCol != null &&
      descCol != null &&
      (useSeparateDebitCredit
          ? (debitCol != null || creditCol != null)
          : amountCol != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accounts = ref.watch(accountsProvider).valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Map CSV Columns',
          style: AppTextStyles.titleLarge
              .copyWith(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          'Match your CSV columns to the correct fields.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 24),
        CsvColumnDropdown(
          label: 'Date column *',
          headers: headers,
          value: dateCol,
          onChanged: onDateCol,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          initialValue: dateFormat,
          decoration: const InputDecoration(labelText: 'Date format'),
          items: const [
            DropdownMenuItem(child: Text('Auto-detect (DD/MM/YYYY default)')),
            DropdownMenuItem(value: 'dd/MM/yyyy', child: Text('DD/MM/YYYY  (e.g. 10/04/2026)')),
            DropdownMenuItem(value: 'MM/dd/yyyy', child: Text('MM/DD/YYYY  (e.g. 04/10/2026)')),
            DropdownMenuItem(value: 'yyyy-MM-dd', child: Text('YYYY-MM-DD  (e.g. 2026-04-10)')),
          ],
          onChanged: onDateFormat,
        ),
        const SizedBox(height: 12),
        CsvColumnDropdown(
          label: 'Description column *',
          headers: headers,
          value: descCol,
          onChanged: onDescCol,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Separate debit/credit columns',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: theme.colorScheme.onSurface)),
          value: useSeparateDebitCredit,
          onChanged: onSeparateToggle,
        ),
        if (useSeparateDebitCredit) ...[
          CsvColumnDropdown(
            label: 'Debit column (money out)',
            headers: headers,
            value: debitCol,
            onChanged: onDebitCol,
          ),
          const SizedBox(height: 12),
          CsvColumnDropdown(
            label: 'Credit column (money in)',
            headers: headers,
            value: creditCol,
            onChanged: onCreditCol,
          ),
        ] else ...[
          CsvColumnDropdown(
            label: 'Amount column * (negative = expense)',
            headers: headers,
            value: amountCol,
            onChanged: onAmountCol,
          ),
        ],
        const SizedBox(height: 12),
        if (accounts.isNotEmpty)
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: accountId,
            decoration: const InputDecoration(labelText: 'Import to account'),
            items: accounts
                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                .toList(),
            onChanged: onAccountId,
          ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _canImport ? onImport : null,
            child: const Text('Start Import'),
          ),
        ),
      ],
    );
  }
}
