import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/goal_type.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/goal_providers.dart';
import '../widgets/add_edit_goal_sheet.dart';
import '../widgets/contributions_section.dart';
import '../widgets/goal_hero_card.dart';
import '../widgets/log_contribution_sheet.dart';
import '../widgets/what_if_simulator.dart';

class GoalDetailPage extends ConsumerWidget {
  const GoalDetailPage({
    super.key,
    required this.goalId,
    this.initialGoal,
  });

  final String goalId;
  final dynamic initialGoal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);
    final contribsAsync = ref.watch(goalContributionsProvider(goalId));
    final theme = Theme.of(context);

    final goal = goalsAsync.valueOrNull
            ?.where((g) => g.id == goalId)
            .firstOrNull ??
        (initialGoal is Goal ? initialGoal as Goal : null);

    if (goal == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isEmergency = goal.type == GoalType.emergencyFund;
    final accentColor =
        isEmergency ? AppColors.warning : AppColors.electricBlue;
    final progress = goal.targetAmount > 0
        ? (goal.currentSaved / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(goal.name, style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _openEdit(context, goal),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          GoalHeroCard(
              goal: goal, progress: progress, accentColor: accentColor),
          const SizedBox(height: 16),
          WhatIfSimulator(goal: goal, accentColor: accentColor),
          const SizedBox(height: 16),
          ContributionsSection(goal: goal, contribsAsync: contribsAsync),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openLogContribution(context, goal),
        icon: const Icon(Icons.add),
        label: const Text('Log contribution'),
      ),
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

  void _openLogContribution(BuildContext context, Goal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => LogContributionSheet(goal: goal),
    );
  }
}
