import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../providers/dashboard_providers.dart';

class MonthlySpendingChart extends StatefulWidget {
  const MonthlySpendingChart({super.key, required this.categories});

  final List<CategorySpend> categories;

  @override
  State<MonthlySpendingChart> createState() => _MonthlySpendingChartState();
}

class _MonthlySpendingChartState extends State<MonthlySpendingChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.categories.fold(0.0, (s, c) => s + c.amount);
    final fmt = NumberFormat('#,##,##0');

    if (widget.categories.isEmpty) return const SizedBox.shrink();

    final sections = widget.categories.asMap().entries.map((e) {
      final isTouched = _touchedIndex == e.key;
      final color = Color(e.value.colorValue);
      return PieChartSectionData(
        value: e.value.amount,
        color: color,
        title: '',
        radius: isTouched ? 60 : 50,
        borderSide: isTouched
            ? BorderSide(color: color, width: 2)
            : const BorderSide(color: Colors.transparent),
      );
    }).toList();

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
            'MONTHLY SPENDING',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 62,
                    sectionsSpace: 3,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          final idx = response
                              ?.touchedSection?.touchedSectionIndex;
                          _touchedIndex =
                              (idx != null && idx >= 0) ? idx : null;
                        });
                      },
                    ),
                  ),
                ),
                _touchedIndex != null
                    ? _TouchedLabel(
                        spend: widget.categories[_touchedIndex!],
                        fmt: fmt,
                      )
                    : _CenterTotal(total: total, fmt: fmt),
              ],
            ),
          ),
          const Divider(height: 24),
          ...widget.categories.asMap().entries.map((e) => _LegendRow(
                spend: e.value,
                total: total,
                isHighlighted: _touchedIndex == e.key,
              )),
        ],
      ),
    );
  }
}

class _CenterTotal extends StatelessWidget {
  const _CenterTotal({required this.total, required this.fmt});

  final double total;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '₹${fmt.format(total)}',
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Spent',
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _TouchedLabel extends StatelessWidget {
  const _TouchedLabel({required this.spend, required this.fmt});

  final CategorySpend spend;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(spend.colorValue);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          spend.name,
          style: AppTextStyles.bodySmall.copyWith(color: color),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          '₹${fmt.format(spend.amount)}',
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.spend,
    required this.total,
    required this.isHighlighted,
  });

  final CategorySpend spend;
  final double total;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(spend.colorValue);
    final pct = total > 0 ? spend.amount / total * 100 : 0.0;
    final fmt = NumberFormat('#,##,##0');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.symmetric(
        horizontal: isHighlighted ? 8 : 4,
        vertical: isHighlighted ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              spend.name,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${pct.toStringAsFixed(1)}%',
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '₹${fmt.format(spend.amount)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
