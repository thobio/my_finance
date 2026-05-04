import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../transactions/domain/models/transaction_type.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../domain/models/slab_line.dart';
import '../../domain/models/tax_deductions.dart';
import '../../domain/models/tax_regime.dart';
import '../../domain/models/tax_result.dart';
import '../providers/tax_providers.dart';

class TaxPage extends ConsumerStatefulWidget {
  const TaxPage({super.key});

  @override
  ConsumerState<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends ConsumerState<TaxPage> {
  late final TextEditingController _income;
  late final TextEditingController _c80c;
  late final TextEditingController _c80d;
  late final TextEditingController _cHra;
  late final TextEditingController _cHli;
  late final TextEditingController _cNps;
  late final TextEditingController _cOther;

  bool _deductionsExpanded = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(taxProvider);
    _income = TextEditingController(
      text: s.annualIncomeRupees > 0 ? s.annualIncomeRupees.toString() : '',
    );
    final d = s.deductions;
    _c80c = TextEditingController(text: _zeroOrEmpty(d.section80C));
    _c80d = TextEditingController(text: _zeroOrEmpty(d.section80D));
    _cHra = TextEditingController(text: _zeroOrEmpty(d.hra));
    _cHli = TextEditingController(text: _zeroOrEmpty(d.homeLoanInterest));
    _cNps = TextEditingController(text: _zeroOrEmpty(d.nps80CCD1B));
    _cOther = TextEditingController(text: _zeroOrEmpty(d.otherDeductions));
  }

  String _zeroOrEmpty(int v) => v > 0 ? v.toString() : '';

  @override
  void dispose() {
    for (final c in [_income, _c80c, _c80d, _cHra, _cHli, _cNps, _cOther]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onIncomeChanged(String v) {
    final parsed = int.tryParse(v) ?? 0;
    ref.read(taxProvider.notifier).setIncome(parsed);
  }

  void _onDeductionChanged() {
    ref.read(taxProvider.notifier).setDeductions(TaxDeductions(
      section80C: int.tryParse(_c80c.text) ?? 0,
      section80D: int.tryParse(_c80d.text) ?? 0,
      hra: int.tryParse(_cHra.text) ?? 0,
      homeLoanInterest: int.tryParse(_cHli.text) ?? 0,
      nps80CCD1B: int.tryParse(_cNps.text) ?? 0,
      otherDeductions: int.tryParse(_cOther.text) ?? 0,
    ));
  }

  void _useIncomeFromTransactions() {
    final transactions = ref.read(transactionsProvider).valueOrNull ?? [];
    final fy = ref.read(taxProvider).fy;
    final fyYear = int.parse(fy.split('-').first);
    final start = DateTime(fyYear, 4);
    final end = DateTime(fyYear + 1, 4);

    final totalRupees = transactions
        .where((t) =>
            t.type == TransactionType.income &&
            !t.date.isBefore(start) &&
            t.date.isBefore(end))
        .fold(0.0, (sum, t) => sum + t.amount)
        .round();

    ref.read(taxProvider.notifier).setIncome(totalRupees);
    _income.text = totalRupees.toString();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taxProvider);
    final results = ref.watch(taxResultsProvider);
    final selected = ref.watch(selectedTaxResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tax Estimator')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _FySelectorRow(
            fy: state.fy,
            regime: state.regime,
            onFyChanged: (v) => ref.read(taxProvider.notifier).setFy(v),
            onRegimeChanged: (v) => ref.read(taxProvider.notifier).setRegime(v),
          ),
          const SizedBox(height: 16),
          _IncomeSection(
            controller: _income,
            onChanged: _onIncomeChanged,
            onUseTxns: _useIncomeFromTransactions,
          ),
          if (state.regime == TaxRegime.old) ...[
            const SizedBox(height: 16),
            _DeductionsSection(
              expanded: _deductionsExpanded,
              onToggle: () => setState(() => _deductionsExpanded = !_deductionsExpanded),
              c80c: _c80c,
              c80d: _c80d,
              cHra: _cHra,
              cHli: _cHli,
              cNps: _cNps,
              cOther: _cOther,
              onChanged: _onDeductionChanged,
              deductionsTotal: state.deductions.total,
            ),
          ],
          const SizedBox(height: 16),
          if (state.annualIncomeRupees > 0) ...[
            _ComparisonCard(results: results),
            const SizedBox(height: 16),
            _SlabBreakdownCard(result: selected),
          ] else
            _EmptyState(),
        ],
      ),
    );
  }
}

// ── FY + Regime Selector ──────────────────────────────────────────────────────

class _FySelectorRow extends StatelessWidget {
  const _FySelectorRow({
    required this.fy,
    required this.regime,
    required this.onFyChanged,
    required this.onRegimeChanged,
  });

  final String fy;
  final TaxRegime regime;
  final ValueChanged<String> onFyChanged;
  final ValueChanged<TaxRegime> onRegimeChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('FY', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(width: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: '2024-25', label: Text('2024-25')),
                    ButtonSegment(value: '2025-26', label: Text('2025-26')),
                  ],
                  selected: {fy},
                  onSelectionChanged: (v) => onFyChanged(v.first),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Regime', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(width: 12),
                SegmentedButton<TaxRegime>(
                  segments: const [
                    ButtonSegment(value: TaxRegime.newRegime, label: Text('New')),
                    ButtonSegment(value: TaxRegime.old, label: Text('Old')),
                  ],
                  selected: {regime},
                  onSelectionChanged: (v) => onRegimeChanged(v.first),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Income Section ────────────────────────────────────────────────────────────

class _IncomeSection extends StatelessWidget {
  const _IncomeSection({
    required this.controller,
    required this.onChanged,
    required this.onUseTxns,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onUseTxns;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Annual Income', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                hintText: '0',
                helperText: 'Gross annual income before deductions',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onChanged,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onUseTxns,
              icon: const Icon(Icons.sync, size: 16),
              label: const Text('Use income from transactions'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Deductions Section (Old Regime) ──────────────────────────────────────────

class _DeductionsSection extends StatelessWidget {
  const _DeductionsSection({
    required this.expanded,
    required this.onToggle,
    required this.c80c,
    required this.c80d,
    required this.cHra,
    required this.cHli,
    required this.cNps,
    required this.cOther,
    required this.onChanged,
    required this.deductionsTotal,
  });

  final bool expanded;
  final VoidCallback onToggle;
  final TextEditingController c80c;
  final TextEditingController c80d;
  final TextEditingController cHra;
  final TextEditingController cHli;
  final TextEditingController cNps;
  final TextEditingController cOther;
  final VoidCallback onChanged;
  final int deductionsTotal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Deductions (Old Regime)'),
            subtitle: deductionsTotal > 0
                ? Text('Total: ₹${_fmt(deductionsTotal)}')
                : null,
            trailing: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            onTap: onToggle,
          ),
          if (expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  _DeductionField(
                    label: 'Section 80C',
                    hint: 'Max ₹1,50,000',
                    controller: c80c,
                    onChanged: onChanged,
                  ),
                  _DeductionField(
                    label: 'Section 80D (Medical)',
                    hint: '₹25K self / ₹50K parents',
                    controller: c80d,
                    onChanged: onChanged,
                  ),
                  _DeductionField(
                    label: 'HRA Exemption',
                    hint: 'As per computation',
                    controller: cHra,
                    onChanged: onChanged,
                  ),
                  _DeductionField(
                    label: 'Home Loan Interest (Sec 24b)',
                    hint: 'Max ₹2,00,000',
                    controller: cHli,
                    onChanged: onChanged,
                  ),
                  _DeductionField(
                    label: 'NPS 80CCD(1B)',
                    hint: 'Max ₹50,000',
                    controller: cNps,
                    onChanged: onChanged,
                  ),
                  _DeductionField(
                    label: 'Other Deductions',
                    hint: '80E, 80G, etc.',
                    controller: cOther,
                    onChanged: onChanged,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DeductionField extends StatelessWidget {
  const _DeductionField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.isLast = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: '₹ ',
          isDense: true,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (_) => onChanged(),
      ),
    );
  }
}

// ── Comparison Card ───────────────────────────────────────────────────────────

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.results});

  final ({TaxResult old, TaxResult newRegime}) results;

  @override
  Widget build(BuildContext context) {
    final oldTax = results.old.netTax;
    final newTax = results.newRegime.netTax;
    final newIsBetter = newTax <= oldTax;
    final saving = (oldTax - newTax).abs();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Regime Comparison', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _RegimeColumn(
                    label: 'Old Regime',
                    tax: oldTax,
                    isRecommended: !newIsBetter,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _RegimeColumn(
                    label: 'New Regime',
                    tax: newTax,
                    isRecommended: newIsBetter,
                  ),
                ),
              ],
            ),
            if (saving > 0) ...[
              const SizedBox(height: 10),
              Text(
                'Save ₹${_fmt(saving)} with ${newIsBetter ? "New" : "Old"} Regime',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RegimeColumn extends StatelessWidget {
  const _RegimeColumn({
    required this.label,
    required this.tax,
    required this.isRecommended,
  });

  final String label;
  final int tax;
  final bool isRecommended;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRecommended
            ? AppColors.electricBlue.withAlpha(20)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: isRecommended
            ? Border.all(color: AppColors.electricBlue.withAlpha(80))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              if (isRecommended) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check_circle, size: 12, color: AppColors.electricBlue),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '₹${_fmt(tax)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isRecommended ? AppColors.electricBlue : null,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Slab Breakdown Card ───────────────────────────────────────────────────────

class _SlabBreakdownCard extends StatelessWidget {
  const _SlabBreakdownCard({required this.result});

  final TaxResult result;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${result.regime.label} — FY ${result.fy}',
              style: tt.titleSmall,
            ),
            const SizedBox(height: 12),

            // Deduction summary
            _SummaryRow(
              label: 'Gross Income',
              value: result.grossIncome,
              context: context,
            ),
            _SummaryRow(
              label: 'Standard Deduction',
              value: -result.standardDeduction,
              context: context,
              isDeduction: true,
            ),
            if (result.deductions > 0)
              _SummaryRow(
                label: 'Other Deductions',
                value: -result.deductions,
                context: context,
                isDeduction: true,
              ),
            const Divider(),
            _SummaryRow(
              label: 'Taxable Income',
              value: result.taxableIncome,
              context: context,
              isBold: true,
            ),
            const SizedBox(height: 12),

            // Slab table
            _SlabTable(slabs: result.slabs, context: context),
            const SizedBox(height: 8),

            // Tax computation summary
            _SummaryRow(label: 'Base Tax', value: result.baseTax, context: context),
            if (result.rebate87A > 0)
              _SummaryRow(
                label: 'Rebate u/s 87A',
                value: -result.rebate87A,
                context: context,
                isDeduction: true,
              ),
            if (result.surcharge > 0)
              _SummaryRow(label: 'Surcharge', value: result.surcharge, context: context),
            _SummaryRow(label: '4% Health & Education Cess', value: result.cess, context: context),
            const Divider(),
            _SummaryRow(
              label: 'Net Tax Payable',
              value: result.netTax,
              context: context,
              isBold: true,
            ),
            const SizedBox(height: 12),

            // Effective rate + TDS
            Row(
              children: [
                _MetricChip(
                  label: 'Effective Rate',
                  value: '${(result.effectiveRate * 100).toStringAsFixed(1)}%',
                  context: context,
                ),
                const SizedBox(width: 8),
                _MetricChip(
                  label: 'Monthly TDS',
                  value: '₹${_fmt(result.monthlyTds)}',
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SlabTable extends StatelessWidget {
  const _SlabTable({required this.slabs, required this.context});

  final List<SlabLine> slabs;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
          children: ['Slab', 'Rate', 'Taxable', 'Tax']
              .map((h) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Text(h, style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                  ))
              .toList(),
        ),
        for (final slab in slabs)
          TableRow(
            children: [
              _cell(_slabLabel(slab), tt, context),
              _cell('${(slab.rate * 100).toStringAsFixed(0)}%', tt, context),
              _cell('₹${_fmt(slab.taxableInSlab)}', tt, context),
              _cell('₹${_fmt(slab.taxForSlab)}', tt, context),
            ],
          ),
      ],
    );
  }

  Widget _cell(String text, TextTheme tt, BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(text, style: tt.bodySmall),
      );

  String _slabLabel(SlabLine slab) {
    final from = _shortFmt(slab.from);
    if (slab.to == null) return '> ₹$from';
    return '₹$from – ₹${_shortFmt(slab.to!)}';
  }

  String _shortFmt(int rupees) {
    if (rupees >= 10000000) return '${(rupees / 10000000).toStringAsFixed(0)}Cr';
    if (rupees >= 100000) return '${(rupees / 100000).toStringAsFixed(0)}L';
    if (rupees >= 1000) return '${(rupees / 1000).toStringAsFixed(0)}K';
    return rupees.toString();
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.context,
    this.isDeduction = false,
    this.isBold = false,
  });

  final String label;
  final int value;
  final BuildContext context;
  final bool isDeduction;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final style = (isBold ? tt.bodyMedium : tt.bodySmall)?.copyWith(
      fontWeight: isBold ? FontWeight.bold : null,
      color: isDeduction ? AppColors.success : null,
    );
    final display = isDeduction ? '−₹${_fmt(-value)}' : '₹${_fmt(value)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(display, style: style),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
    required this.context,
  });

  final String label;
  final String value;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
          Text(value, style: tt.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calculate_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your annual income above',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Formatters ────────────────────────────────────────────────────────────────

String _fmt(int rupees) {
  if (rupees < 0) return _fmt(-rupees);
  if (rupees >= 10000000) {
    final cr = rupees / 10000000;
    return '${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)}Cr';
  }
  if (rupees >= 100000) {
    final l = rupees / 100000;
    return '${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 2)}L';
  }
  // comma formatting
  final s = rupees.toString();
  if (s.length <= 3) return s;
  final rev = s.split('').reversed.toList();
  final result = <String>[];
  for (var i = 0; i < rev.length; i++) {
    if (i == 3 || (i > 3 && (i - 3) % 2 == 0)) result.add(',');
    result.add(rev[i]);
  }
  return result.reversed.join();
}
