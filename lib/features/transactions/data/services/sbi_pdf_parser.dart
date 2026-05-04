import 'package:csv/csv.dart';
import 'package:pdfrx/pdfrx.dart';

/// Parses SBI bank statement PDFs into a normalised CSV.
///
/// Output columns: Date, Description, Debit, Credit, Balance
/// (Date is the Value Date in DD/MM/YYYY format.)
class SbiPdfParser {
  static final _dateRe = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  static final _amountRe = RegExp(r'^\d[\d,]*(\.\d+)?$');

  // ── Public API ───────────────────────────────────────────────────────────────

  /// Returns true when the first page's text contains SBI markers.
  static bool isSbi(List<PdfPageTextFragment> firstPageFrags) {
    final text = firstPageFrags.map((f) => f.text).join(' ').toLowerCase();
    return text.contains('state bank of india') ||
        (text.contains('account statement') && text.contains('ifsc'));
  }

  /// Parses all pages into a CSV string.
  /// Returns null if no transactions are found (not an SBI statement or empty).
  static String? parse(List<List<PdfPageTextFragment>> pages) {
    _ColLayout? layout;
    final txns = <_Txn>[];

    for (final frags in pages) {
      if (frags.isEmpty) continue;
      final rows = _toRows(frags);
      layout ??= _findLayout(rows);
      if (layout == null) continue;
      _parseRows(rows, layout, txns);
    }

    if (txns.isEmpty) return null;

    final csvRows = <List<String>>[
      ['Date', 'Description', 'Debit', 'Credit', 'Balance'],
      ...txns.map((t) => [
            _isoDate(t.date),
            _simplifyDescription(t.description.trim(), t.debit.isNotEmpty),
            _cleanAmount(t.debit),
            _cleanAmount(t.credit),
            _cleanAmount(t.balance),
          ]),
    ];
    return const ListToCsvConverter().convert(csvRows);
  }

  // Converts DD/MM/YYYY → YYYY-MM-DD so CsvImportService.parseDate recognises it.
  static String _isoDate(String ddMmYyyy) {
    final p = ddMmYyyy.split('/');
    return p.length == 3 ? '${p[2]}-${p[1]}-${p[0]}' : ddMmYyyy;
  }

  // Strips commas and trailing CR/DR suffixes from an amount string.
  static String _cleanAmount(String raw) {
    return raw
        .replaceAll(',', '')
        .replaceAll(RegExp(r'\s*(CR|DR)\s*$', caseSensitive: false), '')
        .trim();
  }

  // ── Description simplification ───────────────────────────────────────────────

  static String _simplifyDescription(String raw, bool isDebit) {
    if (raw.isEmpty) return raw;

    final up = raw.toUpperCase();

    // UPI transfers — format: UPI/<ref>/<payee>/<vpa>/<bank>
    if (up.startsWith('UPI/')) {
      final parts = raw.split('/');
      // parts[0]=UPI, parts[1]=ref/DR/CR, parts[2]=payee name, ...
      String direction;
      String payee;
      if (parts.length >= 3) {
        // Detect direction from the narration segment (DR/CR) or fall back to column
        final seg1 = parts[1].toUpperCase();
        final seg2 = parts.length > 2 ? parts[2].toUpperCase() : '';
        if (seg1 == 'DR' || seg2 == 'DR') {
          direction = 'DR';
          payee = _upiPayee(parts, isDr: true);
        } else if (seg1 == 'CR' || seg2 == 'CR') {
          direction = 'CR';
          payee = _upiPayee(parts, isDr: false);
        } else {
          direction = isDebit ? 'DR' : 'CR';
          payee = _upiPayee(parts, isDr: isDebit);
        }
      } else {
        direction = isDebit ? 'DR' : 'CR';
        payee = parts.length > 1 ? parts.last : raw;
      }
      final label = 'UPI/$direction - $payee';
      return _appendRefund(label, up);
    }

    // ATM withdrawals
    if (up.contains('ATM')) {
      // e.g. "ATM-00000123 MUMBAI BR"  or  "CASH WDL ATM THANE"
      final location = _extractAfter(raw, RegExp(r'ATM[-\s]*\S*\s*', caseSensitive: false)).trim();
      final label = location.isNotEmpty ? 'ATM CASH - $location' : 'ATM CASH';
      return _appendRefund(label, up);
    }

    // IMPS transfers
    if (up.startsWith('IMPS')) {
      final remainder = raw.replaceFirst(RegExp(r'^IMPS[/\-\s]*', caseSensitive: false), '').trim();
      final label = remainder.isNotEmpty ? 'IMPS - $remainder' : 'IMPS';
      return _appendRefund(label, up);
    }

    // POS purchases
    if (up.startsWith('POS ') || up.startsWith('POS/') || up.startsWith('POS-')) {
      final merchant = raw.replaceFirst(RegExp(r'^POS[/\-\s]+', caseSensitive: false), '').trim();
      final label = merchant.isNotEmpty ? 'POS - $merchant' : 'POS';
      return _appendRefund(label, up);
    }

    // NEFT transfers
    if (up.startsWith('NEFT')) {
      final remainder = raw.replaceFirst(RegExp(r'^NEFT[/\-\s]*', caseSensitive: false), '').trim();
      final label = remainder.isNotEmpty ? 'NEFT - $remainder' : 'NEFT';
      return _appendRefund(label, up);
    }

    // Standalone refund/reversal
    return _appendRefund(raw, up);
  }

  static String _upiPayee(List<String> parts, {required bool isDr}) {
    // SBI UPI narration variants:
    //   UPI/DR/<ref>/<payee>/<vpa>
    //   UPI/<ref>/DR/<payee>/<vpa>
    //   UPI/CR/<ref>/<payee>/<vpa>
    // The payee is typically the first segment that is not a direction marker,
    // a pure numeric ref, a VPA (contains @), or a bank code.
    for (var i = 1; i < parts.length; i++) {
      final p = parts[i].trim();
      if (p.isEmpty) continue;
      if (p.toUpperCase() == 'DR' || p.toUpperCase() == 'CR') continue;
      if (RegExp(r'^\d+$').hasMatch(p)) continue; // numeric reference
      if (p.contains('@')) continue; // VPA
      if (p.length <= 4 && p == p.toUpperCase()) continue; // short bank code
      return p;
    }
    return parts.last;
  }

  static String _extractAfter(String raw, RegExp pattern) {
    return raw.replaceFirst(pattern, '');
  }

  static String _appendRefund(String label, String upperRaw) {
    if (upperRaw.contains('REFUND') ||
        upperRaw.contains('REVERSAL') ||
        upperRaw.contains(' REV ') ||
        upperRaw.endsWith(' REV')) {
      return '$label (Refund)';
    }
    return label;
  }

  // ── Row clustering ───────────────────────────────────────────────────────────

  static List<_Row> _toRows(List<PdfPageTextFragment> frags) {
    const yTol = 4.0;
    final map = <double, List<PdfPageTextFragment>>{};

    for (final f in frags) {
      if (f.text.trim().isEmpty) continue;
      final y = f.bounds.top;
      double? key;
      for (final k in map.keys) {
        if ((k - y).abs() < yTol) {
          key = k;
          break;
        }
      }
      (map[key ?? y] ??= []).add(f);
    }

    // Descending y = top-to-bottom in PDF coordinate space (y increases upward).
    final ys = map.keys.toList()..sort((a, b) => b.compareTo(a));
    return ys.map((y) {
      final row = map[y]!..sort((a, b) => a.bounds.left.compareTo(b.bounds.left));
      return _Row(y: y, frags: row);
    }).toList();
  }

  // ── Header / layout detection ────────────────────────────────────────────────

  static _ColLayout? _findLayout(List<_Row> rows) {
    for (int i = 0; i < rows.length; i++) {
      // Merge up to 4 adjacent rows — some SBI formats split header into multiple lines.
      String combined = _rowText(rows[i]);
      for (int k = 1; k <= 3 && i + k < rows.length; k++) {
        if ((rows[i].y - rows[i + k].y).abs() < 30) {
          combined += ' ${_rowText(rows[i + k])}';
        }
      }

      final low = combined.toLowerCase();
      if (!low.contains('debit') && !low.contains('withdrawal')) continue;
      if (!low.contains('credit') && !low.contains('deposit')) continue;
      // Date/narration column required — broadened to cover SBI format variants.
      final hasDateOrNarration = low.contains('date') ||
          low.contains('value') ||
          low.contains('txn') ||
          low.contains('particulars') ||
          low.contains('narration') ||
          low.contains('description') ||
          low.contains('reference') ||
          low.contains('cheque') ||
          low.contains('remarks');
      if (!hasDateOrNarration) continue;

      double? debitX, creditX, balanceX;
      double dateX = double.infinity;

      // Scan this row and up to 3 following rows for header fragments.
      final headerFrags = [
        ...rows[i].frags,
        for (int k = 1; k <= 3 && i + k < rows.length; k++)
          if ((rows[i].y - rows[i + k].y).abs() < 30) ...rows[i + k].frags,
      ];

      for (final f in headerFrags) {
        final t = f.text.toLowerCase().trim();
        if (t.contains('debit') || t.contains('withdrawal') || t == 'dr') {
          debitX = f.bounds.center.x;
        } else if (t.contains('credit') || t.contains('deposit') || t == 'cr') {
          creditX = f.bounds.center.x;
        } else if (t.contains('balance')) {
          balanceX = f.bounds.left;
        } else if ((t == 'value' || t.contains('date') || t.contains('txn') ||
                t.contains('particular')) &&
            f.bounds.left < dateX) {
          dateX = f.bounds.left;
        }
      }

      if (debitX == null || creditX == null) continue;

      return _ColLayout(
        dateX: dateX == double.infinity ? 0 : dateX,
        debitX: debitX,
        creditX: creditX,
        balanceX: balanceX ?? (creditX + (creditX - debitX) * 0.8),
      );
    }
    return null;
  }

  static String _rowText(_Row row) =>
      row.frags.map((f) => f.text).join(' ');

  // ── Transaction extraction ───────────────────────────────────────────────────

  static void _parseRows(List<_Row> rows, _ColLayout layout, List<_Txn> out) {
    _Txn? current;

    for (final row in rows) {
      String? valueDate;
      final detailParts = <String>[];
      String debit = '';
      String credit = '';
      String balance = '';
      bool hasAmountCol = false;

      for (final frag in row.frags) {
        final x = frag.bounds.center.x;
        final t = frag.text.trim();
        if (t.isEmpty) continue;

        if (x >= layout.balanceX) {
          // Balance column — capture the last amount-like value on this row.
          if (_amountRe.hasMatch(t.replaceAll(',', ''))) balance = t;
        } else if ((x - layout.creditX).abs() < layout.colHalfWidth) {
          if (t != '-' && !_dateRe.hasMatch(t)) credit = t;
          hasAmountCol = true;
        } else if ((x - layout.debitX).abs() < layout.colHalfWidth) {
          if (t != '-' && !_dateRe.hasMatch(t)) debit = t;
          hasAmountCol = true;
        } else if (x < layout.detailsCutoff) {
          // Date or post-date area
          if (_dateRe.hasMatch(t) && valueDate == null) {
            valueDate = t;
          }
        } else {
          // Details / narration column
          detailParts.add(t);
        }
      }

      final desc = detailParts.join(' ');

      // Skip opening/closing balance summary rows.
      final descUp = desc.toUpperCase();
      if (descUp.contains('OPENING BALANCE') || descUp.contains('CLOSING BALANCE')) {
        current = null;
        continue;
      }

      if (valueDate != null) {
        current = _Txn(
          date: valueDate,
          description: desc,
          debit: debit,
          credit: credit,
          balance: balance,
        );
        out.add(current);
      } else if (current != null) {
        if (desc.isNotEmpty) current.description += ' $desc';
        if (debit.isNotEmpty && current.debit.isEmpty) current.debit = debit;
        if (credit.isNotEmpty && current.credit.isEmpty) current.credit = credit;
        if (balance.isNotEmpty) current.balance = balance;
        // A row with amounts but no date and no description is a subtotal/footer — stop continuation.
        if (hasAmountCol && desc.isEmpty) current = null;
      }
    }
  }
}

// ── Internal types ────────────────────────────────────────────────────────────

class _Row {
  const _Row({required this.y, required this.frags});
  final double y;
  final List<PdfPageTextFragment> frags;
}

class _ColLayout {
  _ColLayout({
    required this.dateX,
    required this.debitX,
    required this.creditX,
    required this.balanceX,
  });

  final double dateX;
  final double debitX;
  final double creditX;
  final double balanceX;

  // Half the spacing between Debit and Credit columns, used as a hit zone.
  double get colHalfWidth => (creditX - debitX) * 0.55;

  // Anything with x >= this is in the Details column (not a date/post-date area).
  double get detailsCutoff => dateX + (debitX - dateX) * 0.30;
}

class _Txn {
  _Txn({
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
  });
  final String date;
  String description;
  String debit;
  String credit;
  String balance;
}
