import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/monthly_obligation.dart';
import '../../domain/models/obligation_priority.dart';
import '../providers/monthly_obligation_providers.dart';

class AddEditObligationSheet extends ConsumerStatefulWidget {
  const AddEditObligationSheet({
    super.key,
    this.existing,
    this.initialYear,
    this.initialMonth,
  });

  final MonthlyObligation? existing;
  final int? initialYear;
  final int? initialMonth;

  static Future<void> show(
    BuildContext context, {
    MonthlyObligation? existing,
    int? initialYear,
    int? initialMonth,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditObligationSheet(
        existing: existing,
        initialYear: initialYear,
        initialMonth: initialMonth,
      ),
    );
  }

  @override
  ConsumerState<AddEditObligationSheet> createState() =>
      _AddEditObligationSheetState();
}

class _AddEditObligationSheetState
    extends ConsumerState<AddEditObligationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  ObligationPriority _priority = ObligationPriority.medium;
  int _dueDay = 1;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _labelCtrl.text = e.label;
      _amountCtrl.text = e.amount.toStringAsFixed(0);
      _notesCtrl.text = e.notes;
      _priority = e.priority;
      _dueDay = e.dueDay;
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final ctrl = ref.read(obligationControllerProvider.notifier);
    final amount = double.parse(_amountCtrl.text.trim());
    final int year = widget.existing?.year ??
        widget.initialYear ??
        ref.read(selectedObligationYearProvider);
    final int month = widget.existing?.month ??
        widget.initialMonth ??
        ref.read(selectedObligationMonthProvider);

    if (widget.existing == null) {
      await ctrl.add(
        label: _labelCtrl.text.trim(),
        amount: amount,
        year: year,
        month: month,
        dueDay: _dueDay,
        priority: _priority,
        notes: _notesCtrl.text.trim(),
      );
    } else {
      await ctrl.update(widget.existing!.copyWith(
        label: _labelCtrl.text.trim(),
        amount: amount,
        dueDay: _dueDay,
        priority: _priority,
        notes: _notesCtrl.text.trim(),
      ));
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref
        .read(obligationControllerProvider.notifier)
        .delete(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _handle(isDark),
                  const SizedBox(height: 8),
                  Text(
                    widget.existing == null
                        ? 'Add Obligation'
                        : 'Edit Obligation',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _labelCtrl,
                    decoration: const InputDecoration(
                      labelText: 'What do you need to pay?',
                      hintText: 'e.g. Car insurance, Friend loan',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Amount (₹)',
                      prefixText: '₹ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final parsed = double.tryParse(v);
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ObligationPriority>(
                    initialValue: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: ObligationPriority.values
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.label),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _priority = v!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Due day: $_dueDay',
                            style: theme.textTheme.bodyMedium),
                      ),
                      Expanded(
                        flex: 2,
                        child: Slider(
                          value: _dueDay.toDouble(),
                          min: 1,
                          max: 28,
                          divisions: 27,
                          label: '$_dueDay',
                          onChanged: (v) =>
                              setState(() => _dueDay = v.round()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'Any extra details',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _save,
                      child: Text(widget.existing == null
                          ? 'Add Obligation'
                          : 'Save'),
                    ),
                  ),
                  if (widget.existing != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _delete,
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.danger),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _handle(bool isDark) => Center(
        child: Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.darkBorder : AppColors.lightBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}
