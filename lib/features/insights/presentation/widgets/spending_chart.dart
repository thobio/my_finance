import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/insights_providers.dart';

class SpendingChart extends ConsumerWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairs = ref.watch(spendingChartProvider);
    if (pairs.isEmpty) {
      return const Center(child: Text('No spending data yet.'));
    }

    final maxAmount = pairs
        .expand((p) => [p.current, p.prev])
        .fold(0.0, (a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegend(context),
        const SizedBox(height: 8),
        ...pairs.map((pair) => _CategoryRow(
              pair: pair,
              maxAmount: maxAmount,
            )),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LegendDot(color: Theme.of(context).colorScheme.primary, label: 'This month'),
        const SizedBox(width: 16),
        _LegendDot(
            color: Theme.of(context).colorScheme.primary.withAlpha(80),
            label: 'Last month'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.pair, required this.maxAmount});

  final CategorySpendPair pair;
  final double maxAmount;

  @override
  Widget build(BuildContext context) {
    final catColor = Color(pair.colorValue);
    final current = pair.current;
    final prev = pair.prev;
    final currentFraction = maxAmount > 0 ? pair.current / maxAmount : 0.0;
    final prevFraction = maxAmount > 0 ? pair.prev / maxAmount : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(color: catColor, shape: BoxShape.circle),
              ),
              Expanded(
                child: Text(pair.name,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis),
              ),
              Text(
                '₹${current.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _Bar(fraction: prevFraction, color: catColor.withAlpha(80)),
          const SizedBox(height: 2),
          _Bar(fraction: currentFraction, color: catColor),
          if (prev > 0)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'prev ₹${prev.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.color});
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: fraction.clamp(0.0, 1.0),
        minHeight: 10,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        color: color,
      ),
    );
  }
}
