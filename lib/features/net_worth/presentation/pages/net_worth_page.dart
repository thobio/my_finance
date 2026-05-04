import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../providers/net_worth_providers.dart';
import '../widgets/add_edit_asset_sheet.dart';
import '../widgets/assets_section.dart';
import '../widgets/liabilities_section.dart';
import '../widgets/net_worth_trend_chart.dart';

class NetWorthPage extends ConsumerWidget {
  const NetWorthPage({super.key});

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final assetsAsync = ref.watch(assetsProvider);
    final snapshotsAsync = ref.watch(netWorthSnapshotsProvider);
    final debtsAsync = ref.watch(debtsProvider);
    final summary = ref.watch(netWorthSummaryProvider);

    final isPositive = summary.netWorth >= 0;
    final netWorthColor = isPositive ? AppColors.success : AppColors.danger;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Net Worth'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save snapshot',
            onPressed: () async {
              await ref.read(assetControllerProvider.notifier).saveSnapshot();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Snapshot saved')),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // ── Net Worth Hero ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'Net Worth',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _fmt(summary.netWorth),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: netWorthColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _badge(
                      context,
                      'Assets: ${_fmt(summary.totalAssets)}',
                      AppColors.success,
                      isDark,
                    ),
                    const SizedBox(width: 12),
                    _badge(
                      context,
                      'Debts: ${_fmt(summary.totalLiabilities)}',
                      AppColors.danger,
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Trend Chart ─────────────────────────────────────────────────
          snapshotsAsync.when(
            loading: () => const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => const SizedBox.shrink(),
            data: (snapshots) =>
                NetWorthTrendChart(snapshots: snapshots),
          ),
          const SizedBox(height: 16),

          // ── Assets Section ──────────────────────────────────────────────
          assetsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
            data: (assets) => AssetsSection(
              assets: assets,
              goalSavings: summary.goalSavings,
              isDark: isDark,
              summary: summary,
            ),
          ),
          const SizedBox(height: 16),

          // ── Liabilities Section ─────────────────────────────────────────
          debtsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
            data: (debts) => LiabilitiesSection(
              debts: debts,
              totalLiabilities: summary.totalLiabilities,
              isDark: isDark,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddEditAssetSheet.show(context),
        tooltip: 'Add asset',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _badge(
      BuildContext context, String text, Color color, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
