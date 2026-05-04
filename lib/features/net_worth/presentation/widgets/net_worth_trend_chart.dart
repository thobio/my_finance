import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../domain/models/net_worth_snapshot.dart';

class NetWorthTrendChart extends StatelessWidget {
  const NetWorthTrendChart({super.key, required this.snapshots});

  final List<NetWorthSnapshot> snapshots;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (snapshots.isEmpty) {
      return Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Worth Trend',
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Snapshot data will appear here over time',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final spots = snapshots.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.netWorth);
    }).toList();

    final minY =
        snapshots.map((s) => s.netWorth).reduce((a, b) => a < b ? a : b);
    final maxY =
        snapshots.map((s) => s.netWorth).reduce((a, b) => a > b ? a : b);
    final padding = ((maxY - minY) * 0.15).abs().clamp(100000.0, double.infinity);

    final isPositive = snapshots.last.netWorth >= 0;
    final lineColor = isPositive ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Worth Trend',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                minY: minY - padding,
                maxY: maxY + padding,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: padding * 2,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= snapshots.length) {
                          return const SizedBox.shrink();
                        }
                        if (snapshots.length > 6 && idx % 2 != 0) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat('MMM').format(snapshots[idx].capturedAt),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withValues(alpha: 0.08),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) =>
                        theme.colorScheme.surfaceContainerHighest,
                    getTooltipItems: (spots) => spots
                        .map((s) => LineTooltipItem(
                              NumberFormat.compactCurrency(
                                      locale: 'en_IN', symbol: '₹')
                                  .format(s.y),
                              AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
