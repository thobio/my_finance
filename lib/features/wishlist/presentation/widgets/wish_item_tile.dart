import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../goals/presentation/providers/goal_providers.dart';
import '../../domain/models/wish_item.dart';
import '../../domain/models/wish_item_status.dart';
import '../providers/wish_providers.dart';
import 'add_edit_wish_sheet.dart';

class WishItemTile extends ConsumerWidget {
  const WishItemTile({super.key, required this.item});

  final WishItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider).valueOrNull ?? [];
    final linkedGoal = goals.where((g) => g.id == item.linkedGoalId).firstOrNull;
    final isPending = item.status == WishItemStatus.pending;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isPending
            ? () => AddEditWishSheet.show(context, item: item)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Status icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _statusColor(item.status).withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _statusIcon(item.status),
                  color: _statusColor(item.status),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: item.status == WishItemStatus.dropped
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '₹${(item.estimatedCost / 100).toStringAsFixed(0)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM y').format(item.desiredMonth),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        if (linkedGoal != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              linkedGoal.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isPending)
                PopupMenuButton<_Action>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  onSelected: (action) => _onAction(context, ref, action),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _Action.achieve,
                      child: Text('Mark achieved'),
                    ),
                    PopupMenuItem(
                      value: _Action.drop,
                      child: Text('Drop'),
                    ),
                    PopupMenuItem(
                      value: _Action.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAction(BuildContext context, WidgetRef ref, _Action action) {
    final ctrl = ref.read(wishControllerProvider.notifier);
    switch (action) {
      case _Action.achieve:
        ctrl.markAchieved(item);
      case _Action.drop:
        ctrl.markDropped(item);
      case _Action.delete:
        ctrl.delete(item.id);
    }
  }

  Color _statusColor(WishItemStatus status) => switch (status) {
        WishItemStatus.pending => const Color(0xFF4F8EFF),
        WishItemStatus.achieved => const Color(0xFF4CAF50),
        WishItemStatus.dropped => const Color(0xFF9E9E9E),
      };

  IconData _statusIcon(WishItemStatus status) => switch (status) {
        WishItemStatus.pending => Icons.favorite_border,
        WishItemStatus.achieved => Icons.check_circle_outline,
        WishItemStatus.dropped => Icons.cancel_outlined,
      };
}

enum _Action { achieve, drop, delete }
