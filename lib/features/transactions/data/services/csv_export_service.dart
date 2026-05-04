import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/category.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/transaction_type.dart';

class CsvExportService {
  static final _dateFmt = DateFormat('yyyy-MM-dd');

  Future<void> export({
    required List<Transaction> transactions,
    required List<Category> categories,
  }) async {
    final catMap = {for (final c in categories) c.id: c.name};

    final rows = <List<dynamic>>[
      ['Date', 'Type', 'Category', 'Description', 'Amount (₹)', 'Notes'],
    ];

    for (final t in transactions) {
      final amount = t.amount;
      final signed = t.type == TransactionType.expense ? -amount : amount;
      rows.add([
        _dateFmt.format(t.date),
        t.type.name,
        catMap[t.categoryId] ?? '',
        t.description,
        signed.toStringAsFixed(2),
        t.notes,
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/transactions_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv',
    );
    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'My Finance — Transactions Export',
    );
  }
}
