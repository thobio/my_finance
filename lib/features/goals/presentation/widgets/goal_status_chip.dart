import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/goal_status.dart';

class GoalStatusChip extends StatelessWidget {
  const GoalStatusChip({super.key, required this.status});

  final GoalStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      GoalStatus.active => ('Active', AppColors.success),
      GoalStatus.achieved => ('Achieved', AppColors.electricBlue),
      GoalStatus.paused => ('Paused', AppColors.warning),
      GoalStatus.abandoned => ('Abandoned', AppColors.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
