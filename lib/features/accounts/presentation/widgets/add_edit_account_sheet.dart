import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/account.dart';
import '../providers/account_providers.dart';

class AddEditAccountSheet extends ConsumerStatefulWidget {
  const AddEditAccountSheet({super.key, this.account});

  final Account? account;

  static Future<void> show(BuildContext context, {Account? account}) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddEditAccountSheet(account: account),
      );

  @override
  ConsumerState<AddEditAccountSheet> createState() =>
      _AddEditAccountSheetState();
}

class _AddEditAccountSheetState extends ConsumerState<AddEditAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _institution;
  late final TextEditingController _lastFour;
  late final TextEditingController _openingBalance;
  late final TextEditingController _creditLimit;
  late AccountType _type;

  bool get _isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    _name = TextEditingController(text: a?.name ?? '');
    _institution = TextEditingController(text: a?.institution ?? '');
    _lastFour = TextEditingController(text: a?.lastFourDigits ?? '');
    _openingBalance = TextEditingController(
      text: a != null ? a.openingBalance.toStringAsFixed(0) : '',
    );
    _creditLimit = TextEditingController(
      text: a?.creditLimit != null
          ? a!.creditLimit!.toStringAsFixed(0)
          : '',
    );
    _type = a?.type ?? AccountType.savings;
  }

  @override
  void dispose() {
    _name.dispose();
    _institution.dispose();
    _lastFour.dispose();
    _openingBalance.dispose();
    _creditLimit.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ctrl = ref.read(accountControllerProvider.notifier);
    final openingBalance = double.tryParse(_openingBalance.text) ?? 0.0;
    final creditLimit = _type == AccountType.creditCard &&
            _creditLimit.text.isNotEmpty
        ? double.tryParse(_creditLimit.text) ?? 0.0
        : null;

    if (_isEditing) {
      await ctrl.update(widget.account!.copyWith(
        name: _name.text.trim(),
        type: _type,
        institution:
            _institution.text.trim().isEmpty ? null : _institution.text.trim(),
        lastFourDigits:
            _lastFour.text.trim().isEmpty ? null : _lastFour.text.trim(),
        openingBalance: openingBalance,
        creditLimit: creditLimit,
      ));
    } else {
      await ctrl.add(
        name: _name.text.trim(),
        type: _type,
        institution:
            _institution.text.trim().isEmpty ? null : _institution.text.trim(),
        lastFourDigits:
            _lastFour.text.trim().isEmpty ? null : _lastFour.text.trim(),
        openingBalance: openingBalance,
        creditLimit: creditLimit,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
            'This removes the account. Existing transactions are kept.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(accountControllerProvider.notifier)
        .delete(widget.account!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _isEditing ? 'Edit Account' : 'Add Account',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (_isEditing)
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.danger),
                      onPressed: _delete,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Account type selector
              _TypeSelector(
                selected: _type,
                onChanged: (t) => setState(() => _type = t),
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Account name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Institution + last 4 in a row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _institution,
                      decoration: const InputDecoration(
                        labelText: 'Bank / Institution',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _lastFour,
                      decoration: const InputDecoration(
                        labelText: 'Last 4 digits',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Opening balance
              TextFormField(
                controller: _openingBalance,
                decoration: const InputDecoration(
                  labelText: 'Opening balance (₹)',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              ),

              // Credit limit (only for credit cards)
              if (_type == AccountType.creditCard) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _creditLimit,
                  decoration: const InputDecoration(
                    labelText: 'Credit limit (₹)',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(_isEditing ? 'Save Changes' : 'Add Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Account type selector chips ───────────────────────────────────────────────

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.selected, required this.onChanged});

  final AccountType selected;
  final ValueChanged<AccountType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AccountType.values.map((t) {
        final isSelected = t == selected;
        return ChoiceChip(
          label: Text(t.label),
          selected: isSelected,
          onSelected: (_) => onChanged(t),
        );
      }).toList(),
    );
  }
}
