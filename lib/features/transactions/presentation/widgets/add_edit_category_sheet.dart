import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/category.dart';
import '../../domain/models/transaction_type.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/transaction_providers.dart';
import 'category_icon.dart';

class AddEditCategorySheet extends ConsumerStatefulWidget {
  const AddEditCategorySheet({super.key, this.category});

  final Category? category;

  @override
  ConsumerState<AddEditCategorySheet> createState() =>
      _AddEditCategorySheetState();
}

class _AddEditCategorySheetState extends ConsumerState<AddEditCategorySheet> {
  final _nameController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String _icon = 'receipt_long';
  int _colorValue = 0xFF42A5F5;

  static const _presetColors = [
    0xFFEF5350, 0xFFEC407A, 0xFFAB47BC, 0xFF7E57C2,
    0xFF5C6BC0, 0xFF42A5F5, 0xFF26C6DA, 0xFF26A69A,
    0xFF66BB6A, 0xFFD4E157, 0xFFFFCA28, 0xFFFFA726,
    0xFFFF7043, 0xFF8D6E63, 0xFF78909C, 0xFF607D8B,
  ];

  @override
  void initState() {
    super.initState();
    final cat = widget.category;
    if (cat != null) {
      _nameController.text = cat.name;
      _type = cat.type;
      _icon = cat.icon;
      _colorValue = cat.colorValue;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final uid = ref.read(authUserProvider).valueOrNull?.uid;
    if (uid == null) return;

    final repo = ref.read(categoryRepositoryProvider);
    final cat = Category(
      id: widget.category?.id ?? 'cat_custom_${const Uuid().v4()}',
      name: name,
      icon: _icon,
      colorValue: _colorValue,
      type: _type,
      isCustom: true,
    );

    if (widget.category != null) {
      await repo.update(uid, cat);
    } else {
      await repo.add(uid, cat);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.category != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEdit ? 'Edit Category' : 'New Category',
            style: AppTextStyles.titleMedium
                .copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 20),

          // Type toggle
          SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(
                value: TransactionType.expense,
                label: Text('Expense'),
                icon: Icon(Icons.arrow_downward, size: 16),
              ),
              ButtonSegment(
                value: TransactionType.income,
                label: Text('Income'),
                icon: Icon(Icons.arrow_upward, size: 16),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 16),

          // Name field
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Category name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),

          // Color picker
          Text(
            'Color',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _presetColors.map((c) {
              final selected = c == _colorValue;
              return GestureDetector(
                onTap: () => setState(() => _colorValue = c),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(c),
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(
                            color: theme.colorScheme.onSurface,
                            width: 2.5,
                          )
                        : null,
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Icon picker
          Text(
            'Icon',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: CategoryIcon.pickerIcons.length,
              itemBuilder: (context, i) {
                final (iconName, label) = CategoryIcon.pickerIcons[i];
                final selected = iconName == _icon;
                return Tooltip(
                  message: label,
                  child: GestureDetector(
                    onTap: () => setState(() => _icon = iconName),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? Color(_colorValue).withValues(alpha: 0.15)
                            : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: selected
                            ? Border.all(color: Color(_colorValue), width: 1.5)
                            : null,
                      ),
                      child: Icon(
                        CategoryIcon.iconDataFor(iconName),
                        size: 22,
                        color: selected
                            ? Color(_colorValue)
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _nameController.text.trim().isEmpty ? null : _save,
              child: Text(isEdit ? 'Save Changes' : 'Create Category'),
            ),
          ),
        ],
      ),
    );
  }
}
