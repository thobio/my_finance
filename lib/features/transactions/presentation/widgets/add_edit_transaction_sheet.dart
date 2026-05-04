import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../accounts/presentation/providers/account_providers.dart';
import '../../../distribution/presentation/widgets/distribution_sheet.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/transaction_type.dart';
import '../providers/transaction_providers.dart';
import 'sheet_handle.dart';
import 'transaction_date_field.dart';
import 'transaction_type_toggle.dart';

class AddEditTransactionSheet extends ConsumerStatefulWidget {
  const AddEditTransactionSheet({super.key, this.existing});

  final Transaction? existing;

  @override
  ConsumerState<AddEditTransactionSheet> createState() =>
      _AddEditTransactionSheetState();
}

class _AddEditTransactionSheetState
    extends ConsumerState<AddEditTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  DateTime _date = DateTime.now();
  String? _categoryId;
  String? _accountId;

  @override
  void initState() {
    super.initState();
    final t = widget.existing;
    if (t != null) {
      _descController.text = t.description;
      _amountController.text = t.amount.toStringAsFixed(2);
      _notesController.text = t.notes;
      _type = t.type;
      _date = t.date;
      _categoryId = t.categoryId;
      _accountId = t.accountId;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final accounts = ref.watch(accountsProvider).valueOrNull ?? [];
    final filteredCats = categories.where((c) => c.type == _type).toList();

    // Reset category if it doesn't match the new type
    if (_categoryId != null &&
        !filteredCats.any((c) => c.id == _categoryId)) {
      _categoryId = null;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          const SheetHandle(),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.existing == null
                          ? 'Add Transaction'
                          : 'Edit Transaction',
                      style: AppTextStyles.titleLarge
                          .copyWith(color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 20),
                    TransactionTypeToggle(
                      value: _type,
                      onChanged: (t) => setState(() => _type = t),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        prefixText: '₹ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter amount';
                        final n = double.tryParse(v);
                        if (n == null || n <= 0) return 'Enter a valid amount';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _categoryId,
                      decoration:
                          const InputDecoration(labelText: 'Category'),
                      items: filteredCats
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _categoryId = v),
                      validator: (v) =>
                          v == null ? 'Select a category' : null,
                    ),
                    const SizedBox(height: 16),
                    if (accounts.isNotEmpty)
                      DropdownButtonFormField<String>(
                        // ignore: deprecated_member_use
                        value: _accountId,
                        decoration:
                            const InputDecoration(labelText: 'Account'),
                        items: accounts
                            .map((a) => DropdownMenuItem(
                                  value: a.id,
                                  child: Text(a.name),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _accountId = v),
                      ),
                    const SizedBox(height: 16),
                    TransactionDateField(
                      date: _date,
                      onChanged: (d) => setState(() => _date = d),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optional)',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _save,
                        child: Text(
                          widget.existing == null
                              ? 'Add Transaction'
                              : 'Save Changes',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final user = ref.read(authUserProvider).valueOrNull;
    if (user == null) return;

    final accounts = ref.read(accountsProvider).valueOrNull ?? [];
    final accountId = _accountId ??
        (accounts.isNotEmpty ? accounts.first.id : 'default');

    final txn = Transaction(
      id: widget.existing?.id ?? const Uuid().v4(),
      accountId: accountId,
      categoryId: _categoryId!,
      amount: amount,
      type: _type,
      date: _date,
      description: _descController.text.trim(),
      notes: _notesController.text.trim(),
    );

    final controller = ref.read(transactionControllerProvider.notifier);
    if (widget.existing == null) {
      await controller.add(txn);
    } else {
      await controller.update(txn);
    }

    if (!mounted) return;
    Navigator.of(context).pop();

    if (_type == TransactionType.income && widget.existing == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          DistributionSheet.show(
            context,
            sourceTransactionId: txn.id,
            income: amount,
          );
        }
      });
    }
  }
}
