import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/transaction.dart';
import '../../domain/models/transaction_source.dart';
import '../../domain/models/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'category_matcher.dart';

class CsvImportResult {
  const CsvImportResult({
    required this.imported,
    required this.duplicates,
    required this.failed,
  });

  final List<Transaction> imported;
  final List<CsvRow> duplicates;
  final List<CsvParseError> failed;

  int get total => imported.length + duplicates.length + failed.length;
}

class CsvRow {
  const CsvRow({required this.rowIndex, required this.raw});
  final int rowIndex;
  final Map<String, String> raw;
}

class CsvParseError {
  const CsvParseError({required this.rowIndex, required this.reason});
  final int rowIndex;
  final String reason;
}

class CsvColumnMap {
  const CsvColumnMap({
    required this.date,
    required this.description,
    required this.amount,
    this.debit,
    this.credit,
    this.type,
    this.notes,
    this.dateFormat,
  });

  final String date;
  final String description;
  // Either a combined signed amount column or separate debit/credit columns
  final String? amount;
  final String? debit;
  final String? credit;
  final String? type;
  final String? notes;
  final String? dateFormat; // e.g. 'dd/MM/yyyy', 'MM-dd-yyyy'
}

class CsvImportService {
  CsvImportService({required TransactionRepository repository})
      : _repository = repository;

  final TransactionRepository _repository;

  List<String> parseHeaders(String csvContent) {
    final rows = const CsvToListConverter(eol: '\n').convert(csvContent);
    if (rows.isEmpty) return [];
    return rows.first.map((e) => e.toString().trim()).toList();
  }

  Future<CsvImportResult> import({
    required String uid,
    required String accountId,
    required String defaultCategoryId,
    required String csvContent,
    required CsvColumnMap columnMap,
  }) async {
    final rows = const CsvToListConverter(eol: '\n').convert(csvContent);
    if (rows.length < 2) {
      return const CsvImportResult(imported: [], duplicates: [], failed: []);
    }

    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final imported = <Transaction>[];
    final duplicates = <CsvRow>[];
    final failed = <CsvParseError>[];

    for (var i = 1; i < rows.length; i++) {
      final cells = rows[i];
      if (cells.isEmpty || cells.every((c) => c.toString().trim().isEmpty)) {
        continue;
      }

      final row = <String, String>{};
      for (var j = 0; j < headers.length && j < cells.length; j++) {
        row[headers[j]] = cells[j].toString().trim();
      }

      try {
        final date = _parseDate(row[columnMap.date] ?? '', columnMap.dateFormat);
        final amount = _parseAmount(row, columnMap);
        final type = amount >= 0 ? TransactionType.income : TransactionType.expense;
        final absAmount = amount.abs();
        final description = row[columnMap.description] ?? '';
        final notes =
            columnMap.notes != null ? (row[columnMap.notes!] ?? '') : '';
        final categoryId =
            CategoryMatcher.matchCategoryId(description, type) ??
                defaultCategoryId;

        final hash = _computeHash(accountId, date, absAmount);
        final isDuplicate = await _repository.hashExists(uid, hash);

        final rawRow = CsvRow(rowIndex: i, raw: row);

        if (isDuplicate) {
          duplicates.add(rawRow);
          continue;
        }

        imported.add(Transaction(
          id: const Uuid().v4(),
          accountId: accountId,
          categoryId: categoryId,
          amount: absAmount,
          type: type,
          date: date,
          description: description,
          notes: notes,
          source: TransactionSource.csv,
          deduplicationHash: hash,
        ));
      } catch (e) {
        failed.add(CsvParseError(rowIndex: i, reason: e.toString()));
      }
    }

    if (imported.isNotEmpty) {
      await _repository.addBatch(uid, imported);
    }

    return CsvImportResult(
      imported: imported,
      duplicates: duplicates,
      failed: failed,
    );
  }

  String _computeHash(String accountId, DateTime date, double amount) {
    final raw = '$accountId|${date.toIso8601String().substring(0, 10)}|$amount';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  double _parseAmount(Map<String, String> row, CsvColumnMap map) {
    if (map.amount != null) {
      return _parseDecimal(row[map.amount!] ?? '');
    }

    if (map.debit != null || map.credit != null) {
      final debit = map.debit != null
          ? _parseDecimal(row[map.debit!] ?? '0')
          : 0.0;
      final credit = map.credit != null
          ? _parseDecimal(row[map.credit!] ?? '0')
          : 0.0;
      // credit = positive (income), debit = negative (expense)
      return credit - debit;
    }

    throw const FormatException('No amount column configured');
  }

  double _parseDecimal(String raw) {
    final cleaned = raw
        .replaceAll(RegExp(r'[₹\$€£,\s]'), '')
        .replaceAll(RegExp(r'(CR|DR)$', caseSensitive: false), '')
        .replaceAll('(', '-')
        .replaceAll(')', '');
    if (cleaned.isEmpty) return 0;
    return double.parse(cleaned);
  }

  DateTime _parseDate(String raw, String? format) {
    if (raw.isEmpty) throw const FormatException('Empty date');

    // Try ISO first
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;

    if (format != null) {
      return _parseDateWithFormat(raw, format);
    }

    // Heuristic: detect common separators
    final sep = raw.contains('/') ? '/' : raw.contains('-') ? '-' : '.';
    final parts = raw.split(sep);
    if (parts.length != 3) throw FormatException('Unrecognised date: $raw');

    final a = int.parse(parts[0]);
    final b = int.parse(parts[1]);
    final c = int.parse(parts[2]);

    if (c > 31) {
      // c is year
      if (a > 12) return DateTime(c, b, a); // a can't be month → DD/MM/YYYY
      if (b > 12) return DateTime(c, a, b); // b can't be month → MM/DD/YYYY
      // Ambiguous (both ≤ 12): default to DD/MM/YYYY (Indian standard)
      return DateTime(c, b, a);
    }
    if (a > 31) {
      // a is year: YYYY/MM/DD
      return DateTime(a, b, c);
    }

    throw FormatException('Unrecognised date format: $raw');
  }

  DateTime _parseDateWithFormat(String raw, String format) {
    final fParts = format.split(RegExp(r'[/\-\.]'));
    final sep = format.contains('/') ? '/' : format.contains('-') ? '-' : '.';
    final vParts = raw.split(sep);

    if (fParts.length != 3 || vParts.length != 3) {
      throw FormatException('Date $raw does not match format $format');
    }

    int? day, month, year;
    for (var i = 0; i < 3; i++) {
      final token = fParts[i].toLowerCase();
      final value = int.parse(vParts[i]);
      if (token.startsWith('d')) day = value;
      if (token.startsWith('m')) month = value;
      if (token.startsWith('y')) year = value;
    }

    return DateTime(year!, month!, day!);
  }
}
