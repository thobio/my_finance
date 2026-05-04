import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../net_worth/presentation/providers/net_worth_providers.dart';

class NetWorthCard extends ConsumerWidget {
  const NetWorthCard({super.key});

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final summary = ref.watch(netWorthSummaryProvider);

    final isPositive = summary.netWorth >= 0;
    final netWorthColor = isPositive ? AppColors.success : AppColors.danger;

    return GestureDetector(
      onTap: () => context.go('/net-worth'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              netWorthColor.withValues(alpha: 0.12),
              netWorthColor.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: netWorthColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: netWorthColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPositive ? Icons.account_balance : Icons.warning_amber_outlined,
                color: netWorthColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Worth',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _fmt(summary.netWorth),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: netWorthColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Assets ${_fmt(summary.totalAssets)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Debts ${_fmt(summary.totalLiabilities)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.danger,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right,
                size: 18,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ],
        ),
      ),
    );
  }
}
