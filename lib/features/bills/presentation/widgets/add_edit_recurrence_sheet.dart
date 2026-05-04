import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/recurrence.dart';
import '../../domain/models/recurrence_frequency.dart';
import '../providers/recurrence_providers.dart';
import 'date_row.dart';

class AddEditRecurrenceSheet extends ConsumerStatefulWidget {
  const AddEditRecurrenceSheet({super.key, this.existing});

  final Recurrence? existing;

  static Future<void> show(BuildContext context, {Recurrence? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditRecurrenceSheet(existing: existing),
    );
  }

  @override
  ConsumerState<AddEditRecurrenceSheet> createState() =>
      _AddEditRecurrenceSheetState();
}

class _AddEditRecurrenceSheetState
    extends ConsumerState<AddEditRecurrenceSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  RecurrenceFrequency _frequency = RecurrenceFrequency.monthly;
  int _dayOfMonth = 1;
  DateTime _startDate = DateTime.now();
  bool _autoPost = false;
  int _reminderDays = 0;
  bool _isVariableAmount = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _isVariableAmount = e.amount == 0;
      _labelCtrl.text = e.label;
      _amountCtrl.text = _isVariableAmount ? '' : e.amount.toStringAsFixed(0);
      _frequency = e.frequency;
      _dayOfMonth = e.dayOfMonth;
      _startDate = e.startDate;
      _autoPost = e.autoPost;
      _reminderDays = e.reminderOffsetDays;
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = _isVariableAmount
        ? 0.0
        : double.parse(_amountCtrl.text);
    final ctrl = ref.read(recurrenceControllerProvider.notifier);

    if (widget.existing == null) {
      await ctrl.add(
        label: _labelCtrl.text.trim(),
        amount: amount,
        categoryId: 'bills',
        frequency: _frequency,
        startDate: _startDate,
        dayOfMonth: _dayOfMonth,
        autoPost: _autoPost,
        reminderOffsetDays: _reminderDays,
      );
    } else {
      await ctrl.update(widget.existing!.copyWith(
        label: _labelCtrl.text.trim(),
        amount: amount,
        frequency: _frequency,
        dayOfMonth: _dayOfMonth,
        autoPost: _autoPost,
        reminderOffsetDays: _reminderDays,
      ));
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref
        .read(recurrenceControllerProvider.notifier)
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                    widget.existing == null ? 'Add Bill' : 'Edit Bill',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _labelCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Bill name',
                      hintText: 'e.g. Netflix, Rent, EMI',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Variable amount'),
                    subtitle: const Text(
                        'Amount changes every cycle (e.g. electricity)'),
                    value: _isVariableAmount,
                    onChanged: (v) => setState(() {
                      _isVariableAmount = v;
                      if (v) _amountCtrl.clear();
                    }),
                  ),
                  if (!_isVariableAmount) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        prefixText: '₹ ',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (v) {
                        if (_isVariableAmount) return null;
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid amount';
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<RecurrenceFrequency>(
                    initialValue: _frequency,
                    decoration: const InputDecoration(labelText: 'Frequency'),
                    items: RecurrenceFrequency.values
                        .map((f) => DropdownMenuItem(
                              value: f,
                              child: Text(f.label),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _frequency = v!),
                  ),
                  if (_frequency == RecurrenceFrequency.monthly ||
                      _frequency == RecurrenceFrequency.everyTwoMonths ||
                      _frequency == RecurrenceFrequency.quarterly ||
                      _frequency == RecurrenceFrequency.yearly) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Day of month: $_dayOfMonth',
                              style: theme.textTheme.bodyMedium),
                        ),
                        Expanded(
                          flex: 2,
                          child: Slider(
                            value: _dayOfMonth.toDouble(),
                            min: 1,
                            max: 28,
                            divisions: 27,
                            label: '$_dayOfMonth',
                            onChanged: (v) =>
                                setState(() => _dayOfMonth = v.round()),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  DateRow(
                    label: 'Start date',
                    date: _startDate,
                    onChanged: (d) => setState(() => _startDate = d),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: Text('Reminder',
                              style: theme.textTheme.bodyMedium)),
                      DropdownButton<int>(
                        value: _reminderDays,
                        items: [0, 1, 2, 3, 5, 7]
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(
                                      d == 0 ? 'None' : '$d day${d > 1 ? 's' : ''} before'),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _reminderDays = v ?? 0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Auto-post transaction'),
                    subtitle:
                        const Text('Automatically log expense when due'),
                    value: _autoPost,
                    onChanged: (v) => setState(() => _autoPost = v),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _save,
                      child: Text(widget.existing == null ? 'Add Bill' : 'Save'),
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
                        child: const Text('Delete bill'),
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
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}
