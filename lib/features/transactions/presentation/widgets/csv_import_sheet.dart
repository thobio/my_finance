import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../accounts/presentation/providers/account_providers.dart';
import '../../data/services/csv_import_service.dart';
import '../providers/transaction_providers.dart';
import 'csv_loading_step.dart';
import 'csv_map_columns_step.dart';
import 'csv_pick_file_step.dart';
import 'csv_result_step.dart';
import 'sheet_handle.dart';

enum _Step { pickFile, mapColumns, importing, result }

class CsvImportSheet extends ConsumerStatefulWidget {
  const CsvImportSheet({super.key});

  @override
  ConsumerState<CsvImportSheet> createState() => _CsvImportSheetState();
}

class _CsvImportSheetState extends ConsumerState<CsvImportSheet> {
  _Step _step = _Step.pickFile;
  String? _csvContent;
  List<String> _headers = [];
  CsvImportResult? _result;

  String? _dateCol;
  String? _dateFormat;
  String? _descCol;
  String? _amountCol;
  String? _debitCol;
  String? _creditCol;
  bool _useSeparateDebitCredit = false;
  String? _accountId;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scroll) => Column(
        children: [
          const SheetHandle(),
          Expanded(
            child: SingleChildScrollView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: _body(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    switch (_step) {
      case _Step.pickFile:
        return CsvPickFileStep(onPicked: _onFilePicked);
      case _Step.mapColumns:
        return CsvMapColumnsStep(
          headers: _headers,
          dateCol: _dateCol,
          dateFormat: _dateFormat,
          descCol: _descCol,
          amountCol: _amountCol,
          debitCol: _debitCol,
          creditCol: _creditCol,
          useSeparateDebitCredit: _useSeparateDebitCredit,
          accountId: _accountId,
          onDateCol: (v) => setState(() => _dateCol = v),
          onDateFormat: (v) => setState(() => _dateFormat = v),
          onDescCol: (v) => setState(() => _descCol = v),
          onAmountCol: (v) => setState(() => _amountCol = v),
          onDebitCol: (v) => setState(() => _debitCol = v),
          onCreditCol: (v) => setState(() => _creditCol = v),
          onSeparateToggle: (v) =>
              setState(() => _useSeparateDebitCredit = v),
          onAccountId: (v) => setState(() => _accountId = v),
          onImport: _runImport,
        );
      case _Step.importing:
        return const CsvLoadingStep();
      case _Step.result:
        return CsvResultStep(
          result: _result!,
          onDone: () => Navigator.pop(context),
        );
    }
  }

  void _onFilePicked(String content, List<String> headers) {
    final hLow = headers.map((h) => h.toLowerCase().trim()).toList();

    String? matchHeader(List<String> candidates) {
      for (final c in candidates) {
        final idx = hLow.indexWhere((h) => h.contains(c));
        if (idx >= 0) return headers[idx];
      }
      return null;
    }

    final autoDate = matchHeader(['date', 'txn date', 'value date', 'transaction date']);
    final autoDesc = matchHeader(['description', 'details', 'narration', 'particulars']);
    final autoDebit = matchHeader(['debit', 'withdrawal', ' dr']);
    final autoCredit = matchHeader(['credit', 'deposit', ' cr']);
    final autoAmount = matchHeader(['amount', 'net amount']);
    final hasSplit = autoDebit != null || autoCredit != null;

    setState(() {
      _csvContent = content;
      _headers = headers;
      _step = _Step.mapColumns;
      _dateCol = autoDate;
      _descCol = autoDesc;
      if (hasSplit) {
        _useSeparateDebitCredit = true;
        _debitCol = autoDebit;
        _creditCol = autoCredit;
      } else if (autoAmount != null) {
        _useSeparateDebitCredit = false;
        _amountCol = autoAmount;
      }
    });
  }

  Future<void> _runImport() async {
    if (_csvContent == null) return;

    final user = ref.read(authUserProvider).valueOrNull;
    if (user == null) return;

    final accounts = ref.read(accountsProvider).valueOrNull ?? [];
    final categories = ref.read(categoriesProvider).valueOrNull ?? [];
    final accountId =
        _accountId ?? (accounts.isNotEmpty ? accounts.first.id : 'default');
    final defaultCategoryId =
        categories.isNotEmpty ? categories.first.id : 'uncategorised';

    setState(() => _step = _Step.importing);

    try {
      final columnMap = CsvColumnMap(
        date: _dateCol!,
        dateFormat: _dateFormat,
        description: _descCol!,
        amount: _useSeparateDebitCredit ? null : _amountCol,
        debit: _useSeparateDebitCredit ? _debitCol : null,
        credit: _useSeparateDebitCredit ? _creditCol : null,
      );

      final result = await ref.read(csvImportServiceProvider).import(
            uid: user.uid,
            accountId: accountId,
            defaultCategoryId: defaultCategoryId,
            csvContent: _csvContent!,
            columnMap: columnMap,
          );

      setState(() {
        _result = result;
        _step = _Step.result;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
        setState(() => _step = _Step.mapColumns);
      }
    }
  }
}
