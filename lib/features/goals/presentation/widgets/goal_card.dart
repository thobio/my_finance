import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/goal_type.dart';
import 'goal_progress_ring.dart';
import 'goal_status_chip.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = goal.targetAmount > 0
        ? (goal.currentSaved / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;
    final isEmergency = goal.type == GoalType.emergencyFund;
    final accentColor =
        isEmergency ? AppColors.warning : AppColors.electricBlue;
    final remaining =
        (goal.targetAmount - goal.currentSaved).clamp(0.0, goal.targetAmount);
    final monthsLeft = _monthsUntil(goal.targetDate);
    final monthlyNeeded =
        monthsLeft > 0 ? (remaining / monthsLeft) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GoalProgressRing(progress: progress, color: accentColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          goal.name,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GoalStatusChip(status: goal.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${_fmt(goal.currentSaved)} / ₹${_fmt(goal.targetAmount)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation(accentColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 11,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4)),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM yyyy').format(goal.targetDate),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      if (monthsLeft > 0 && monthlyNeeded > 0) ...[
                        const SizedBox(width: 10),
                        Text(
                          '₹${_fmt(monthlyNeeded)}/mo needed',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                            color: accentColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert,
                  size: 18,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  int _monthsUntil(DateTime date) {
    final now = DateTime.now();
    return math.max(
      0,
      (date.year - now.year) * 12 + date.month - now.month,
    );
  }

  String _fmt(double v) => NumberFormat('#,##,##0').format(v);
}
