import 'package:flutter/material.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../providers/dashboard_providers.dart';
import 'category_spend_row.dart';

class TopCategoriesCard extends StatelessWidget {
  const TopCategoriesCard({super.key, required this.categories});

  final List<CategorySpend> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (categories.isEmpty) return const SizedBox.shrink();

    final maxAmount =
        categories.fold(0.0, (m, c) => c.amount > m ? c.amount : m);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Spending Categories',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          ...categories.map((c) => CategorySpendRow(
                spend: c,
                maxAmount: maxAmount,
              )),
        ],
      ),
    );
  }
}
