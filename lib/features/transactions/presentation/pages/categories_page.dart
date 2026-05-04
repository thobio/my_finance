import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/category.dart';
import '../../domain/models/transaction_type.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/transaction_providers.dart';
import '../widgets/add_edit_category_sheet.dart';
import '../widgets/category_icon.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(categoriesProvider).valueOrNull ?? [];
    final expense = cats.where((c) => c.type == TransactionType.expense).toList();
    final income = cats.where((c) => c.type == TransactionType.income).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView(
        children: [
          _SectionHeader(
            label: 'EXPENSE',
            count: expense.length,
            color: AppColors.danger,
          ),
          ...expense.map((c) => _CategoryTile(category: c)),
          _SectionHeader(
            label: 'INCOME',
            count: income.length,
            color: AppColors.success,
          ),
          ...income.map((c) => _CategoryTile(category: c)),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAdd(context),
        icon: const Icon(Icons.add),
        label: const Text('New Category'),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddEditCategorySheet(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.bodySmall.copyWith(color: color),
            ),
          ),
          const Spacer(),
          Text(
            theme.brightness == Brightness.dark ? '' : '',
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = Color(category.colorValue);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: CategoryIcon(category: category),
      title: Text(
        category.name,
        style: AppTextStyles.bodyLarge.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        category.isCustom ? 'Custom' : 'Default',
        style: AppTextStyles.bodySmall.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
      ),
      trailing: category.isCustom
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined,
                      size: 20, color: color.withValues(alpha: 0.8)),
                  onPressed: () => _openEdit(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: AppColors.danger.withValues(alpha: 0.8)),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            )
          : Icon(
              Icons.lock_outline,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
            ),
    );
  }

  void _openEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddEditCategorySheet(category: category),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete category?'),
        content: Text(
          '"${category.name}" will be removed. Transactions using it '
          'will show as Uncategorized.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final uid = ref.read(authUserProvider).valueOrNull?.uid;
      if (uid != null) {
        await ref.read(categoryRepositoryProvider).delete(uid, category.id);
      }
    }
  }
}
