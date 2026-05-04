import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../transactions/data/services/sbi_pdf_parser.dart';

class CsvPickFileStep extends StatefulWidget {
  const CsvPickFileStep({super.key, required this.onPicked});

  final void Function(String content, List<String> headers) onPicked;

  @override
  State<CsvPickFileStep> createState() => _CsvPickFileStepState();
}

class _CsvPickFileStepState extends State<CsvPickFileStep> {
  bool _loading = false;
  String? _error;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Statement',
          style: AppTextStyles.titleLarge
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload your bank statement as a CSV, Excel (.xlsx / .xls), PDF, '
          'or a password-protected ZIP. Most Indian banks send statements as '
          'a ZIP, Excel, or PDF secured with your date of birth or account '
          'number.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          enabled: !_loading,
          decoration: InputDecoration(
            labelText: 'File password (optional)',
            hintText: 'e.g. DDMMYYYY, account number',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file_outlined),
            label: Text(_loading ? 'Opening file…' : 'Choose File'),
            onPressed: _loading ? null : _pick,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Supported: CSV · Excel (.xlsx, .xls) · PDF · ZIP (password-protected)',
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.45),
            ),
          ),
        ),
      ],
    );
  }

  // No BuildContext parameter — uses State.context which is safe with
  // a mounted guard.
  Future<void> _pick() async {
    setState(() => _error = null);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls', 'pdf', 'zip'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    final name = file.name.toLowerCase();

    final prePassword = _passwordController.text.trim();

    if (name.endsWith('.zip')) {
      if (!mounted) return;
      final password = prePassword.isNotEmpty
          ? prePassword
          : await _showPasswordDialog();
      if (password == null) return;
      setState(() => _loading = true);
      try {
        final csvContent = _extractContentFromZip(bytes, password);
        if (mounted) _complete(csvContent);
      } catch (e) {
        if (mounted) {
          setState(() => _error = _zipErrorMessage(e));
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
      return;
    }

    setState(() => _loading = true);

    if (name.endsWith('.pdf')) {
      try {
        final csvContent = await _pdfToCsv(
          bytes,
          prePassword: prePassword.isNotEmpty ? prePassword : null,
        );
        if (csvContent != null && mounted) _complete(csvContent);
      } catch (e) {
        if (mounted) {
          setState(() => _error = _pdfErrorMessage(e));
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
      return;
    }

    try {
      final csvContent = (name.endsWith('.xlsx') || name.endsWith('.xls'))
          ? _xlsxToCsv(bytes)
          : _decodeCsvBytes(bytes);
      if (mounted) _complete(csvContent);
    } catch (_) {
      if (mounted) setState(() => _error = _excelErrorMessage(bytes));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── ZIP extraction ─────────────────────────────────────────────────────────

  String _extractContentFromZip(Uint8List bytes, String password) {
    final archive = ZipDecoder().decodeBytes(bytes, password: password);

    ArchiveFile? csvEntry;
    ArchiveFile? xlsxEntry;

    for (final entry in archive.files) {
      if (!entry.isFile) continue;
      final n = entry.name.toLowerCase();
      if (n.endsWith('.csv')) {
        csvEntry ??= entry;
      } else if (n.endsWith('.xlsx') || n.endsWith('.xls')) {
        xlsxEntry ??= entry;
      }
    }

    if (csvEntry != null) {
      return _decodeCsvBytes(Uint8List.fromList(csvEntry.content as List<int>));
    }
    if (xlsxEntry != null) {
      return _xlsxToCsv(Uint8List.fromList(xlsxEntry.content as List<int>));
    }

    throw const FormatException(
        'No CSV or Excel file found inside the ZIP archive.');
  }

  // ── XLSX / XLS → CSV conversion ────────────────────────────────────────────

  String _xlsxToCsv(Uint8List bytes) {
    final workbook = Excel.decodeBytes(bytes);

    Sheet? sheet;
    for (final s in workbook.tables.values) {
      if (s.rows.isNotEmpty) {
        sheet = s;
        break;
      }
    }
    if (sheet == null) throw const FormatException('No data found in Excel file.');

    final rows = <List<String>>[];
    for (final row in sheet.rows) {
      final cells = row.map(_cellValue).toList();
      if (cells.every((c) => c.isEmpty)) continue;
      rows.add(cells);
    }

    if (rows.isEmpty) throw const FormatException('Excel sheet is empty.');

    return const ListToCsvConverter().convert(rows);
  }

  String _cellValue(Data? cell) {
    if (cell == null || cell.value == null) return '';
    final v = cell.value!;
    if (v is TextCellValue) return v.value.toString();
    if (v is IntCellValue) return '${v.value}';
    if (v is DoubleCellValue) return '${v.value}';
    if (v is BoolCellValue) return v.value ? 'TRUE' : 'FALSE';
    if (v is DateCellValue) {
      return '${v.year}-'
          '${v.month.toString().padLeft(2, '0')}-'
          '${v.day.toString().padLeft(2, '0')}';
    }
    if (v is DateTimeCellValue) {
      final dt = v.asDateTimeLocal();
      return '${dt.year}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')}';
    }
    return v.toString();
  }

  String _excelErrorMessage(Uint8List bytes) {
    final isOle = bytes.length >= 8 &&
        bytes[0] == 0xD0 &&
        bytes[1] == 0xCF &&
        bytes[2] == 0x11 &&
        bytes[3] == 0xE0;
    if (isOle) {
      return 'This Excel file is password-protected with Office encryption, '
          'which cannot be decrypted here.\n\n'
          'To import:\n'
          '1. Open the file in Excel or Google Sheets (enter the password)\n'
          '2. Save or export it as CSV\n'
          '3. Import the CSV file here\n\n'
          'Common bank passwords: date of birth (DDMMYYYY), '
          'account number, or PAN.';
    }
    return 'Could not read the file. '
        'Make sure it is a valid CSV or Excel file and try again.';
  }

  String _zipErrorMessage(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('password') || msg.contains('mac')) {
      return 'Wrong password for this ZIP file.\n\n'
          'Common bank passwords:\n'
          '• Date of birth: DDMMYYYY (e.g. 27021991)\n'
          '• Account number (last 4–6 digits)\n'
          '• PAN number (e.g. ABCDE1234F)\n\n'
          'Try without the name prefix — most banks use only the date.';
    }
    if (msg.contains('no csv') || msg.contains('no excel') || msg.contains('found')) {
      return 'The ZIP does not contain a CSV or Excel file. '
          'Please check you selected the correct file.';
    }
    return 'Could not open the ZIP file ($e). '
        'Make sure it is a valid bank statement ZIP.';
  }

  String _pdfErrorMessage(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('password') || msg.contains('decrypt') || msg.contains('incorrect')) {
      return 'Wrong password for this PDF.\n\n'
          'Common bank passwords:\n'
          '• Date of birth: DDMMYYYY (e.g. 27021991)\n'
          '• Account number (last 4–6 digits)\n'
          '• PAN number (e.g. ABCDE1234F)';
    }
    return 'Could not read the PDF ($e). '
        'Make sure it is a valid bank statement PDF.';
  }

  // ── CSV helpers ────────────────────────────────────────────────────────────

  String _decodeCsvBytes(Uint8List bytes) {
    try {
      return utf8.decode(bytes);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }

  void _complete(String csvContent) {
    final rows = const CsvToListConverter().convert(csvContent);
    if (rows.isEmpty) return;
    final headers = rows.first.map((e) => e.toString().trim()).toList();
    widget.onPicked(csvContent, headers);
  }

  // ── PDF → CSV conversion ───────────────────────────────────────────────────

  // Returns null when the user cancels the password dialog.
  // [prePassword] skips the dialog and uses the supplied password directly.
  Future<String?> _pdfToCsv(Uint8List bytes, {String? prePassword}) async {
    var cancelled = false;
    PdfDocument? doc;
    try {
      doc = await PdfDocument.openData(
        bytes,
        passwordProvider: prePassword != null
            ? createSimplePasswordProvider(prePassword)
            : () async {
                if (!mounted) {
                  cancelled = true;
                  return null;
                }
                final pw = await _showPasswordDialog(
                  title: 'PDF Password',
                  hint: 'This PDF is password-protected. '
                      'Common passwords: date of birth (DDMMYYYY), '
                      'account number, or PAN.',
                );
                if (pw == null) cancelled = true;
                return pw;
              },
      );
    } catch (_) {
      if (cancelled) return null;
      rethrow;
    }

    try {
      // Load text fragments for every page.
      final pageFragments = <List<PdfPageTextFragment>>[];
      for (final page in doc.pages) {
        final pageText = await page.loadText();
        pageFragments.add(pageText.fragments);
      }

      // Try SBI-specific parser first.
      if (pageFragments.isNotEmpty &&
          SbiPdfParser.isSbi(pageFragments.first)) {
        final sbiCsv = SbiPdfParser.parse(pageFragments);
        if (sbiCsv != null) return sbiCsv;
        // SBI detected but table layout not found — don't fall through to the
        // generic extractor which would dump account metadata as fake rows.
        throw const FormatException(
          'This looks like an SBI statement but the transaction table could not be located.\n\n'
          'Try:\n'
          '• Make sure the PDF is not a summary-only or mini-statement\n'
          '• Export a full account statement from SBI YONO or Net Banking\n'
          '• If the PDF is password-protected, enter the password before selecting it',
        );
      }

      // Generic fallback: cluster fragments into rows and emit CSV.
      final allRows = <List<String>>[];
      for (final frags in pageFragments) {
        if (frags.isEmpty) continue;
        allRows.addAll(_fragmentsToRows(frags));
      }
      if (allRows.isEmpty) {
        throw const FormatException('No text found in the PDF.');
      }
      return const ListToCsvConverter().convert(allRows);
    } finally {
      await doc.dispose();
    }
  }

  List<List<String>> _fragmentsToRows(List<PdfPageTextFragment> fragments) {
    // Cluster fragments by y-position into visual rows.
    // PDF coords: y increases upward, top > bottom; same line has similar `top`.
    const tolerance = 3.0;
    final rowMap = <double, List<PdfPageTextFragment>>{};

    for (final frag in fragments) {
      if (frag.text.trim().isEmpty) continue;
      final y = frag.bounds.top;
      double? key;
      for (final k in rowMap.keys) {
        if ((k - y).abs() < tolerance) {
          key = k;
          break;
        }
      }
      (rowMap[key ?? y] ??= []).add(frag);
    }

    // Sort rows top-to-bottom (descending y in PDF coords).
    final sortedYs = rowMap.keys.toList()..sort((a, b) => b.compareTo(a));

    final rows = <List<String>>[];
    for (final y in sortedYs) {
      final frags = rowMap[y]!
        ..sort((a, b) => a.bounds.left.compareTo(b.bounds.left));

      final cells = <String>[];
      var current = '';
      double? lastRight;

      for (final frag in frags) {
        final gap = lastRight == null ? 0.0 : frag.bounds.left - lastRight;
        if (lastRight != null && gap > 15.0) {
          cells.add(current.trim());
          current = frag.text;
        } else {
          current +=
              (current.isNotEmpty && gap > 1.0 ? ' ' : '') + frag.text;
        }
        lastRight = frag.bounds.right;
      }
      if (current.trim().isNotEmpty) cells.add(current.trim());
      if (cells.any((c) => c.isNotEmpty)) rows.add(cells);
    }
    return rows;
  }

  // ── Password dialog ────────────────────────────────────────────────────────

  Future<String?> _showPasswordDialog({
    String title = 'ZIP Password',
    String hint = 'This ZIP file is password-protected. '
        'Common passwords: date of birth (DDMMYYYY), '
        'account number, or PAN.',
  }) async {
    final controller = TextEditingController();
    bool obscure = true;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hint,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: obscure,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setLocal(() => obscure = !obscure),
                  ),
                ),
                onSubmitted: (_) => Navigator.pop(ctx, controller.text),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Open'),
            ),
          ],
        ),
      ),
    );
  }
}
