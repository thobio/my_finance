import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../insights/domain/models/health_pillars.dart';
import '../../../insights/presentation/providers/insights_providers.dart';
import '../../../insights/presentation/widgets/health_score_ring.dart';

class HealthScoreCard extends ConsumerWidget {
  const HealthScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillars = ref.watch(healthScoreProvider);
    final insightCount = ref.watch(activeInsightsProvider).length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/analytics'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: pillars.hasData
              ? Row(
                  children: [
                    HealthScoreRing(score: pillars.total, size: 80),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Financial Health',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _scoreLabel(pillars.total),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          if (insightCount > 0) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 14, color: Color(0xFFFF9800)),
                                const SizedBox(width: 4),
                                Text(
                                  '$insightCount insight${insightCount > 1 ? 's' : ''} to review',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: const Color(0xFFFF9800),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                )
              : Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 40,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Financial Health',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add data to see your score',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
        ),
      ),
    );
  }

  String _scoreLabel(int score) {
    if (score >= 80) return 'Excellent — keep it up!';
    if (score >= 70) return 'Good — a few areas to improve.';
    if (score >= 50) return 'Fair — take action on insights.';
    return 'Needs attention — review insights.';
  }
}

// Mini arc widget for tight spaces (e.g. dashboard summary grid)
class MiniHealthArc extends StatelessWidget {
  const MiniHealthArc({super.key, required this.pillars});

  final HealthPillars pillars;

  @override
  Widget build(BuildContext context) {
    return HealthScoreRing(score: pillars.total, size: 48);
  }
}
