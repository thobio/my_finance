import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/insights_providers.dart';
import '../widgets/health_pillars_row.dart';
import '../widgets/health_score_ring.dart';
import '../widgets/insight_card.dart';
import '../widgets/spending_chart.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillars = ref.watch(healthScoreProvider);
    final insights = ref.watch(activeInsightsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Health & Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Health Score ──────────────────────────────────────────────
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: pillars.hasData
                  ? Column(
                      children: [
                        Text(
                          'Financial Health Score',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 16),
                        HealthScoreRing(score: pillars.total),
                        const SizedBox(height: 20),
                        HealthPillarsRow(pillars: pillars),
                      ],
                    )
                  : const _NoDataPlaceholder(
                      icon: Icons.favorite_border,
                      message: 'Add accounts and transactions to see your financial health score.',
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Spending Chart ────────────────────────────────────────────
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spending by Category',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const SpendingChart(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Insights ─────────────────────────────────────────────────
          if (insights.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Insights',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${insights.length}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Swipe to dismiss',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InsightCard(insight: insight),
              ),
            ),
          ] else
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: pillars.hasData
                      ? const Column(
                          children: [
                            Icon(Icons.check_circle_outline, size: 40, color: Color(0xFF4CAF50)),
                            SizedBox(height: 8),
                            Text('No active insights — you\'re doing great!'),
                          ],
                        )
                      : const _NoDataPlaceholder(
                          icon: Icons.lightbulb_outline,
                          message: 'Add your financial data to get personalised insights.',
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoDataPlaceholder extends StatelessWidget {
  const _NoDataPlaceholder({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
