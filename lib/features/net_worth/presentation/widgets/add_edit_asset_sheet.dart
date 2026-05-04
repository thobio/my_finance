import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/asset_type.dart';
import '../providers/net_worth_providers.dart';

class AddEditAssetSheet extends ConsumerStatefulWidget {
  const AddEditAssetSheet({super.key, this.existing});

  final Asset? existing;

  static Future<void> show(BuildContext context, {Asset? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditAssetSheet(existing: existing),
    );
  }

  @override
  ConsumerState<AddEditAssetSheet> createState() => _AddEditAssetSheetState();
}

class _AddEditAssetSheetState extends ConsumerState<AddEditAssetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  AssetType _type = AssetType.savings;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _labelCtrl.text = e.label;
      _valueCtrl.text = e.value.toStringAsFixed(0);
      _type = e.type;
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final value = double.parse(_valueCtrl.text.trim());
    final ctrl = ref.read(assetControllerProvider.notifier);

    if (widget.existing == null) {
      await ctrl.add(
        label: _labelCtrl.text.trim(),
        type: _type,
        value: value,
      );
    } else {
      await ctrl.update(widget.existing!.copyWith(
        label: _labelCtrl.text.trim(),
        type: _type,
        value: value,
      ));
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref.read(assetControllerProvider.notifier).delete(widget.existing!.id);
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
                    widget.existing == null ? 'Add Asset' : 'Edit Asset',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _labelCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Label',
                      hintText: 'e.g. SBI Savings, Zerodha Portfolio',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AssetType>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: AssetType.values
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.label),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _valueCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Current value (₹)',
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final parsed = double.tryParse(v);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _save,
                      child: Text(widget.existing == null ? 'Add Asset' : 'Save'),
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
                        child: const Text('Delete asset'),
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
