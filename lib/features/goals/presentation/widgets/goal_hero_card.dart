import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/goal.dart';
import 'big_ring_painter.dart';
import 'goal_stat_box.dart';

class GoalHeroCard extends StatelessWidget {
  const GoalHeroCard({
    super.key,
    required this.goal,
    required this.progress,
    required this.accentColor,
  });

  final Goal goal;
  final double progress;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saved = goal.currentSaved;
    final target = goal.targetAmount;
    final remaining = (target - saved).clamp(0.0, target);
    final monthsLeft = _monthsUntil(goal.targetDate);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(130, 130),
                  painter: BigRingPainter(
                    progress: progress,
                    color: accentColor,
                    bgColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.titleLarge.copyWith(color: accentColor),
                    ),
                    Text(
                      'saved',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              GoalStatBox(
                label: 'Saved',
                value: '₹${_fmt(saved)}',
                color: accentColor,
              ),
              GoalStatBox(
                label: 'Target',
                value: '₹${_fmt(target)}',
                color: theme.colorScheme.onSurface,
              ),
              GoalStatBox(
                label: 'Remaining',
                value: '₹${_fmt(remaining)}',
                color: AppColors.danger,
              ),
              GoalStatBox(
                label: 'Months left',
                value: monthsLeft > 0 ? '$monthsLeft' : 'Past due',
                color: monthsLeft > 0
                    ? theme.colorScheme.onSurface
                    : AppColors.danger,
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _monthsUntil(DateTime date) {
    final now = DateTime.now();
    return math.max(0, (date.year - now.year) * 12 + date.month - now.month);
  }

  String _fmt(double v) => NumberFormat('#,##,##0').format(v);
}
