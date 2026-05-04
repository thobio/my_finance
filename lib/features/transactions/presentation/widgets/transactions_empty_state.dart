import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';

class TransactionsEmptyState extends StatelessWidget {
  const TransactionsEmptyState({super.key, required this.hasSearch});

  final bool hasSearch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.receipt_long_outlined,
            size: 56,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.25),
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No results' : 'No transactions yet',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first transaction',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
