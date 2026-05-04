import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class BudgetSectionHeader extends StatelessWidget {
  const BudgetSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onAdd,
  });

  final String title;
  final String subtitle;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.titleSmall
                    .copyWith(color: theme.colorScheme.onSurface)),
            Text(subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.electricBlue,
          ),
        ),
      ],
    );
  }
}
