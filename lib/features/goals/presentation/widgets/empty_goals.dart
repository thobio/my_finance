import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmptyGoals extends StatelessWidget {
  const EmptyGoals({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 56,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 16),
          Text(
            'No goals yet',
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onAdd,
            child: Text(
              'Create your first goal',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.electricBlue),
            ),
          ),
        ],
      ),
    );
  }
}
