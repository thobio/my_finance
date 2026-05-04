import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/goal.dart';
import '../providers/goal_providers.dart';
import '../widgets/add_edit_goal_sheet.dart';
import '../widgets/empty_goals.dart';
import '../widgets/goal_card.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: goalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (goals) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Goals',
                    style: AppTextStyles.headlineMedium
                        .copyWith(color: theme.colorScheme.onSurface),
                  ),
                ),
              ),
              if (goals.isEmpty)
                SliverFillRemaining(
                  child: EmptyGoals(onAdd: () => _openAdd(context)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GoalCard(
                          goal: goals[i],
                          onTap: () => context.push(
                            '/goals/${goals[i].id}',
                            extra: goals[i],
                          ),
                          onEdit: () => _openEdit(context, goals[i]),
                          onDelete: () =>
                              _confirmDelete(context, ref, goals[i].id),
                        ),
                      ),
                      childCount: goals.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context),
        tooltip: 'Add goal',
        child: const Icon(Icons.add),
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
      builder: (_) => const AddEditGoalSheet(),
    );
  }

  void _openEdit(BuildContext context, Goal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddEditGoalSheet(goal: goal),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String goalId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete goal?'),
        content: const Text('All contributions will also be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(goalControllerProvider.notifier).delete(goalId);
    }
  }
}
