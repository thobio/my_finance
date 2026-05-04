import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_type.dart';
import '../providers/debt_providers.dart';

class AddEditDebtSheet extends ConsumerStatefulWidget {
  const AddEditDebtSheet({super.key, this.existing});

  final Debt? existing;

  static Future<void> show(BuildContext context, {Debt? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditDebtSheet(existing: existing),
    );
  }

  @override
  ConsumerState<AddEditDebtSheet> createState() => _AddEditDebtSheetState();
}

class _AddEditDebtSheetState extends ConsumerState<AddEditDebtSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _outstandingCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _minPaymentCtrl = TextEditingController();
  final _creditLimitCtrl = TextEditingController();

  DebtType _type = DebtType.loan;
  int _dueDay = 1;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _labelCtrl.text = e.label;
      _outstandingCtrl.text = e.outstanding.toStringAsFixed(2);
      _rateCtrl.text = e.interestRatePercent.toStringAsFixed(2);
      _minPaymentCtrl.text = e.minimumPayment.toStringAsFixed(2);
      if (e.creditLimit != null) {
        _creditLimitCtrl.text = e.creditLimit!.toStringAsFixed(2);
      }
      _type = e.type;
      _dueDay = e.dueDay;
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _outstandingCtrl.dispose();
    _rateCtrl.dispose();
    _minPaymentCtrl.dispose();
    _creditLimitCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final outstanding = double.parse(_outstandingCtrl.text.trim());
    final rate = double.parse(_rateCtrl.text.trim());
    final minPayment = double.parse(_minPaymentCtrl.text.trim());
    final creditLimit = _type == DebtType.creditCard &&
            _creditLimitCtrl.text.trim().isNotEmpty
        ? double.parse(_creditLimitCtrl.text.trim())
        : null;

    final ctrl = ref.read(debtControllerProvider.notifier);

    if (widget.existing == null) {
      await ctrl.add(
        label: _labelCtrl.text.trim(),
        type: _type,
        outstanding: outstanding,
        interestRatePercent: rate,
        minimumPayment: minPayment,
        dueDay: _dueDay,
        creditLimit: creditLimit,
      );
    } else {
      await ctrl.update(widget.existing!.copyWith(
        label: _labelCtrl.text.trim(),
        type: _type,
        outstanding: outstanding,
        interestRatePercent: rate,
        minimumPayment: minPayment,
        dueDay: _dueDay,
        creditLimit: creditLimit,
      ));
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref
        .read(debtControllerProvider.notifier)
        .delete(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    widget.existing == null ? 'Add Debt' : 'Edit Debt',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _labelCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Label',
                      hintText: 'e.g. HDFC Credit Card, Home Loan',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DebtType>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: DebtType.values
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.label),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _outstandingCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Outstanding balance (₹)',
                      prefixText: '₹ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  TextFormField(
                    controller: _rateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Annual interest rate (%)',
                      suffixText: '%',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid rate';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _minPaymentCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Minimum monthly payment (₹)',
                      prefixText: '₹ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  if (_type == DebtType.creditCard) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _creditLimitCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Credit limit (₹, optional)',
                        prefixText: '₹ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                    ),
                  ],
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _save,
                      child: Text(widget.existing == null ? 'Add Debt' : 'Save'),
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
                        child: const Text('Delete debt'),
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
