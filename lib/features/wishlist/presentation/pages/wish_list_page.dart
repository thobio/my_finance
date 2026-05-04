import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/wish_item_status.dart';
import '../providers/wish_providers.dart';
import '../widgets/add_edit_wish_sheet.dart';
import '../widgets/wish_item_tile.dart';

class WishListPage extends ConsumerWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(wishItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wish List')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          final pending =
              items.where((i) => i.status == WishItemStatus.pending).toList();
          final done = items
              .where((i) => i.status != WishItemStatus.pending)
              .toList();

          if (items.isEmpty) {
            return _EmptyState(
              onAdd: () => AddEditWishSheet.show(context),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              if (pending.isNotEmpty) ...[
                _SectionHeader(
                  icon: Icons.favorite_border,
                  title: 'Pending',
                  count: pending.length,
                ),
                const SizedBox(height: 8),
                ...pending.map((i) => WishItemTile(item: i)),
              ],
              if (done.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionHeader(
                  icon: Icons.history,
                  title: 'History',
                  count: done.length,
                ),
                const SizedBox(height: 8),
                ...done.map((i) => WishItemTile(item: i)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddEditWishSheet.show(context),
        tooltip: 'Add wish',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
  });

  final IconData icon;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border,
            size: 56,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'Your wish list is empty',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Add things you\'re saving towards.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add a wish'),
          ),
        ],
      ),
    );
  }
}
