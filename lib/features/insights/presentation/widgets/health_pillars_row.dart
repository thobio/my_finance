import 'package:flutter/material.dart';

import '../../domain/models/health_pillars.dart';

class HealthPillarsRow extends StatelessWidget {
  const HealthPillarsRow({super.key, required this.pillars});

  final HealthPillars pillars;

  @override
  Widget build(BuildContext context) {
    final scores = pillars.scores;
    const maxes = HealthPillars.maxScores;
    const labels = HealthPillars.labels;

    return Row(
      children: List.generate(scores.length, (i) {
        final fraction = maxes[i] > 0 ? scores[i] / maxes[i] : 0.0;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labels[i],
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: _pillarColor(fraction),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${scores[i]}/${maxes[i]}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Color _pillarColor(double fraction) {
    if (fraction >= 0.7) return const Color(0xFF4CAF50);
    if (fraction >= 0.5) return const Color(0xFFFF9800);
    return const Color(0xFFEF5350);
  }
}
