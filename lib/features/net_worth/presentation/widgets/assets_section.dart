import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/asset_type.dart';
import '../providers/net_worth_providers.dart';
import 'add_edit_asset_sheet.dart';

class AssetsSection extends StatelessWidget {
  const AssetsSection({
    super.key,
    required this.assets,
    required this.goalSavings,
    required this.isDark,
    required this.summary,
  });

  final List<Asset> assets;
  final double goalSavings;
  final bool isDark;
  final NetWorthSummary summary;

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  IconData _iconFor(AssetType type) => switch (type) {
        AssetType.savings => Icons.account_balance_outlined,
        AssetType.investment => Icons.trending_up,
        AssetType.property => Icons.home_outlined,
        AssetType.vehicle => Icons.directions_car_outlined,
        AssetType.other => Icons.category_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, size: 18, color: AppColors.success),
              const SizedBox(width: 8),
              Text(
                'Assets',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                _fmt(summary.totalAssets),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (assets.isEmpty && goalSavings == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No manual assets yet. Tap + to add one.',
                style: theme.textTheme.bodySmall?.copyWith(color: secondary),
              ),
            ),
          ...assets.map((a) => _AssetRow(
                icon: _iconFor(a.type),
                label: a.label,
                value: _fmt(a.value),
                isDark: isDark,
                onTap: () => AddEditAssetSheet.show(context, existing: a),
              )),
          if (goalSavings > 0) ...[
            if (assets.isNotEmpty) const SizedBox(height: 4),
            _AssetRow(
              icon: Icons.flag_outlined,
              label: 'Goal savings',
              value: _fmt(goalSavings),
              isDark: isDark,
              onTap: null,
              isReadOnly: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
    this.isReadOnly = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback? onTap;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isReadOnly) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 16, color: secondary),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return GestureDetector(onTap: onTap, child: row);
  }
}
