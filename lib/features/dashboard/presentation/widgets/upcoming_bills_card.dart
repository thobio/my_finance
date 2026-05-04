import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../bills/presentation/providers/recurrence_providers.dart';

class UpcomingBillsCard extends ConsumerWidget {
  const UpcomingBillsCard({super.key, required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recurrencesAsync = ref.watch(recurrencesProvider);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final upcoming = recurrencesAsync.valueOrNull
            ?.where((r) {
              final diff = r.nextDueDate.difference(DateTime.now()).inDays;
              return diff >= 0 && diff <= 7;
            })
            .take(3)
            .toList() ??
        [];

    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 4),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded,
                    color: AppColors.danger, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Upcoming Bills',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(onPressed: onViewAll, child: const Text('View all')),
              ],
            ),
          ),
          ...upcoming.map((r) {
            final daysLeft = r.nextDueDate.difference(DateTime.now()).inDays;
            return ListTile(
              dense: true,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: AppColors.danger, size: 18),
              ),
              title: Text(
                r.label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                daysLeft == 0
                    ? 'Due today'
                    : 'Due in $daysLeft day${daysLeft > 1 ? 's' : ''}',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: AppColors.danger),
              ),
              trailing: Text(
                NumberFormat.currency(
                        locale: 'en_IN', symbol: '₹', decimalDigits: 0)
                    .format(r.amount),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
