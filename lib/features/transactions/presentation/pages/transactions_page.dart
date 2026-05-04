import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/services/csv_export_service.dart';
import '../../domain/models/category.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/transaction_type.dart';
import '../providers/transaction_providers.dart';
import '../widgets/add_edit_transaction_sheet.dart';
import '../widgets/csv_import_sheet.dart';
import '../widgets/transaction_date_divider.dart';
import '../widgets/transaction_list_tile.dart';
import '../widgets/transactions_empty_state.dart';
import '../widgets/transactions_header.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  String _search = '';
  TransactionType? _typeFilter;
  final _searchController = TextEditingController();
  final _exportService = CsvExportService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txnAsync = ref.watch(transactionsProvider);
    final catsAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            TransactionsHeader(
              searchController: _searchController,
              onSearch: (v) => setState(() => _search = v),
              typeFilter: _typeFilter,
              onTypeFilter: (v) => setState(() => _typeFilter = v),
              onCsvImport: () => _showCsvImport(context),
              onCsvExport: () {
                final txns = txnAsync.valueOrNull ?? [];
                final cats = catsAsync.valueOrNull ?? [];
                _exportCsv(txns, cats);
              },
            ),
            Expanded(
              child: txnAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (txns) {
                  final cats = catsAsync.valueOrNull ?? [];
                  final filtered = _filter(txns);
                  if (filtered.isEmpty) {
                    return TransactionsEmptyState(hasSearch: _search.isNotEmpty);
                  }
                  final grouped = _group(filtered);
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: grouped.length,
                    itemBuilder: (ctx, i) {
                      final entry = grouped[i];
                      if (entry is _DateHeader) {
                        return TransactionDateDivider(label: entry.label);
                      }
                      final t = (entry as _TxnEntry).txn;
                      final cat = _catFor(cats, t.categoryId, t.type);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: TransactionListTile(
                          transaction: t,
                          category: cat,
                          onTap: () => _openEdit(context, t),
                          onDelete: () => _delete(t.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context),
        tooltip: 'Add transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Transaction> _filter(List<Transaction> txns) {
    return txns.where((t) {
      if (_typeFilter != null && t.type != _typeFilter) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return t.description.toLowerCase().contains(q) ||
            t.notes.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  List<Object> _group(List<Transaction> txns) {
    final result = <Object>[];
    String? lastLabel;
    for (final t in txns) {
      final label = _dayLabel(t.date);
      if (label != lastLabel) {
        result.add(_DateHeader(label));
        lastLabel = label;
      }
      result.add(_TxnEntry(t));
    }
    return result;
  }

  String _dayLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(d);
  }

  Category? _catFor(List<Category> cats, String id, TransactionType type) {
    try {
      final cat = cats.firstWhere((c) => c.id == id);
      return cat.type == type ? cat : null;
    } catch (_) {
      return null;
    }
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddEditTransactionSheet(),
    );
  }

  void _openEdit(BuildContext context, Transaction t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddEditTransactionSheet(existing: t),
    );
  }

  void _delete(String id) {
    ref.read(transactionControllerProvider.notifier).delete(id);
  }

  Future<void> _exportCsv(
      List<Transaction> txns, List<Category> cats) async {
    if (txns.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No transactions to export')),
        );
      }
      return;
    }
    try {
      await _exportService.export(transactions: txns, categories: cats);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  void _showCsvImport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CsvImportSheet(),
    );
  }
}

// Data holders for list grouping — not widgets, kept here intentionally
class _DateHeader {
  const _DateHeader(this.label);
  final String label;
}

class _TxnEntry {
  const _TxnEntry(this.txn);
  final Transaction txn;
}
