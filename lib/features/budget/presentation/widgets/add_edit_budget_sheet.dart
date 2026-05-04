import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/budget.dart';
import '../providers/budget_providers.dart';
import 'budget_entry_row.dart';
import 'budget_section_header.dart';

class AddEditBudgetSheet extends ConsumerStatefulWidget {
  const AddEditBudgetSheet({super.key, this.budget});

  final Budget? budget;

  @override
  ConsumerState<AddEditBudgetSheet> createState() =>
      _AddEditBudgetSheetState();
}

class _AddEditBudgetSheetState extends ConsumerState<AddEditBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _incomeCtrl;

  final List<BudgetEntry> _obligations = [];
  final List<BudgetEntry> _allocations = [];

  @override
  void initState() {
    super.initState();
    final b = widget.budget;
    _incomeCtrl = TextEditingController(
      text: b != null ? b.totalProjectedIncome.toStringAsFixed(0) : '',
    );
    if (b != null) {
      _obligations.addAll(b.fixedObligations.entries
          .map((e) => BudgetEntry(e.key, e.value.toStringAsFixed(0))));
      _allocations.addAll(b.monthlyAllocations.entries
          .map((e) => BudgetEntry(e.key, e.value.toStringAsFixed(0))));
    }
    if (_obligations.isEmpty) _obligations.add(BudgetEntry('', ''));
    if (_allocations.isEmpty) _allocations.add(BudgetEntry('', ''));
  }

  @override
  void dispose() {
    _incomeCtrl.dispose();
    for (final e in _obligations) {
      e.dispose();
    }
    for (final e in _allocations) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = ref.read(authUserProvider).valueOrNull?.uid ?? '';
    final year = ref.read(selectedBudgetYearProvider);
    final income = double.parse(_incomeCtrl.text.trim());

    final obligations = <String, double>{};
    for (final e in _obligations) {
      final name = e.nameCtrl.text.trim();
      final amt = double.tryParse(e.amountCtrl.text.trim()) ?? 0.0;
      if (name.isNotEmpty && amt > 0) obligations[name] = amt;
    }

    final allocations = <String, double>{};
    for (final e in _allocations) {
      final name = e.nameCtrl.text.trim();
      final amt = double.tryParse(e.amountCtrl.text.trim()) ?? 0.0;
      if (name.isNotEmpty && amt > 0) allocations[name] = amt;
    }

    final budget = Budget(
      id: year.toString(),
      uid: uid,
      year: year,
      totalProjectedIncome: income,
      fixedObligations: obligations,
      monthlyAllocations: allocations,
    );

    await ref.read(budgetControllerProvider.notifier).saveBudget(budget);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.budget == null ? 'Set Up Budget' : 'Edit Budget',
                style: AppTextStyles.titleLarge
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 20),

              // Annual income
              TextFormField(
                controller: _incomeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Annual projected income (₹)',
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Fixed obligations
              BudgetSectionHeader(
                title: 'Fixed Monthly Obligations',
                subtitle: 'Rent, EMIs, SIPs, etc.',
                onAdd: () =>
                    setState(() => _obligations.add(BudgetEntry('', ''))),
              ),
              const SizedBox(height: 8),
              ..._obligations.asMap().entries.map((entry) => BudgetEntryRow(
                    entry: entry.value,
                    onRemove: _obligations.length > 1
                        ? () =>
                            setState(() => _obligations.removeAt(entry.key))
                        : null,
                    amountLabel: '/mo',
                  )),
              const SizedBox(height: 20),

              // Monthly allocations
              BudgetSectionHeader(
                title: 'Monthly Allocations',
                subtitle: 'Food, Transport, Entertainment, etc.',
                onAdd: () =>
                    setState(() => _allocations.add(BudgetEntry('', ''))),
              ),
              const SizedBox(height: 8),
              ..._allocations.asMap().entries.map((entry) => BudgetEntryRow(
                    entry: entry.value,
                    onRemove: _allocations.length > 1
                        ? () =>
                            setState(() => _allocations.removeAt(entry.key))
                        : null,
                    amountLabel: '/mo',
                  )),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(widget.budget == null
                      ? 'Create budget'
                      : 'Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
