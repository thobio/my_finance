import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/goal_type.dart';
import '../providers/goal_providers.dart';
import 'goal_type_chip.dart';

class AddEditGoalSheet extends ConsumerStatefulWidget {
  const AddEditGoalSheet({super.key, this.goal});

  final Goal? goal;

  @override
  ConsumerState<AddEditGoalSheet> createState() => _AddEditGoalSheetState();
}

class _AddEditGoalSheetState extends ConsumerState<AddEditGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _targetCtrl;
  late final TextEditingController _savedCtrl;
  late GoalType _type;
  late DateTime _targetDate;

  bool get _isEditing => widget.goal != null;

  @override
  void initState() {
    super.initState();
    final g = widget.goal;
    _nameCtrl = TextEditingController(text: g?.name ?? '');
    _targetCtrl = TextEditingController(
      text: g != null ? g.targetAmount.toStringAsFixed(0) : '',
    );
    _savedCtrl = TextEditingController(
      text: g != null && g.currentSaved > 0
          ? g.currentSaved.toStringAsFixed(0)
          : '',
    );
    _type = g?.type ?? GoalType.standard;
    _targetDate = g?.targetDate ??
        DateTime(DateTime.now().year, DateTime.now().month + 6);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    _savedCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime(now.year, now.month + 1),
      lastDate: DateTime(now.year + 30),
      helpText: 'Target date',
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = ref.read(authUserProvider).valueOrNull?.uid ?? '';
    final targetAmount = double.parse(_targetCtrl.text.trim());
    final saved = _savedCtrl.text.trim().isEmpty
        ? 0.0
        : double.parse(_savedCtrl.text.trim());
    final ctrl = ref.read(goalControllerProvider.notifier);

    if (_isEditing) {
      await ctrl.update(widget.goal!.copyWith(
        name: _nameCtrl.text.trim(),
        targetAmount: targetAmount,
        currentSaved: saved,
        targetDate: _targetDate,
        type: _type,
      ));
    } else {
      await ctrl.add(
        uid: uid,
        name: _nameCtrl.text.trim(),
        targetAmount: targetAmount,
        targetDate: _targetDate,
        startDate: DateTime.now(),
        currentSaved: saved,
        goalType: _type,
      );
    }

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
              _isEditing ? 'Edit Goal' : 'New Goal',
              style: AppTextStyles.titleLarge
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 20),

            // Type selector
            Row(
              children: [
                GoalTypeChip(
                  label: 'Savings Goal',
                  selected: _type == GoalType.standard,
                  onTap: () => setState(() => _type = GoalType.standard),
                ),
                const SizedBox(width: 8),
                GoalTypeChip(
                  label: 'Emergency Fund',
                  selected: _type == GoalType.emergencyFund,
                  onTap: () =>
                      setState(() => _type = GoalType.emergencyFund),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Goal name'),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // Target amount
            TextFormField(
              controller: _targetCtrl,
              decoration: const InputDecoration(
                labelText: 'Target amount (₹)',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                final parsed = double.tryParse(v);
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Already saved
            TextFormField(
              controller: _savedCtrl,
              decoration: const InputDecoration(
                labelText: 'Already saved (₹, optional)',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),

            // Target date
            InkWell(
              onTap: _pickTargetDate,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Target date',
                  suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                ),
                child: Text(
                  DateFormat('d MMM yyyy').format(_targetDate),
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: theme.colorScheme.onSurface),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: Text(_isEditing ? 'Save changes' : 'Create goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
