import 'package:uuid/uuid.dart';

import '../../../budget/domain/models/budget.dart';
import '../../../goals/domain/models/goal.dart';
import '../../../goals/domain/models/goal_status.dart';
import '../models/distribution.dart';
import '../models/distribution_line.dart';

class DistributionEngine {
  const DistributionEngine();

  /// Builds a Distribution from an income transaction.
  ///
  /// Allocation order:
  ///   1. Fixed obligations (from budget)
  ///   2. Goal contributions (active goals, sorted by priority asc then targetDate asc)
  ///   3. Category allocations (proportional to budget.monthlyAllocations)
  ///   4. Any remainder is added as an "Unallocated" line if > 0
  Distribution compute({
    required String uid,
    required String sourceTransactionId,
    required double income,
    required Budget? budget,
    required List<Goal> goals,
  }) {
    final lines = <DistributionLine>[];
    var remaining = income;

    // Step 1: Fixed obligations
    if (budget != null) {
      for (final entry in budget.fixedObligations.entries) {
        final amount = entry.value.clamp(0.0, remaining);
        if (amount > 0) {
          lines.add(DistributionLine(
            label: entry.key,
            amount: amount,
            type: DistributionLineType.fixedObligation,
          ));
          remaining -= amount;
        }
      }
    }

    // Step 2: Goal contributions (active goals by priority, then soonest deadline)
    final activeGoals = goals
        .where((g) => g.status == GoalStatus.active && g.monthlyContribution > 0)
        .toList()
      ..sort((a, b) {
        final byPriority = a.priority.compareTo(b.priority);
        return byPriority != 0 ? byPriority : a.targetDate.compareTo(b.targetDate);
      });

    for (final goal in activeGoals) {
      if (remaining <= 0) break;
      final amount = goal.monthlyContribution.clamp(0.0, remaining);
      if (amount > 0) {
        lines.add(DistributionLine(
          label: goal.name,
          amount: amount,
          type: DistributionLineType.goalContribution,
          goalId: goal.id,
        ));
        remaining -= amount;
      }
    }

    // Step 3: Category allocations (proportional to monthly budget)
    if (budget != null && remaining > 0) {
      final totalBudget = budget.monthlyAllocations.values.fold(0.0, (a, b) => a + b);
      if (totalBudget > 0) {
        var distributed = 0.0;
        final entries = budget.monthlyAllocations.entries.toList();
        for (var i = 0; i < entries.length; i++) {
          final entry = entries[i];
          final double amount;
          if (i == entries.length - 1) {
            amount = remaining - distributed;
          } else {
            amount = (entry.value / totalBudget) * remaining;
          }
          if (amount > 0) {
            lines.add(DistributionLine(
              label: entry.key,
              amount: amount,
              type: DistributionLineType.categoryAllocation,
            ));
            distributed += amount;
          }
        }
        remaining -= distributed;
      }
    }

    // Step 4: Unallocated remainder
    if (remaining > 0) {
      lines.add(DistributionLine(
        label: 'Unallocated',
        amount: remaining,
        type: DistributionLineType.categoryAllocation,
      ));
    }

    return Distribution(
      id: const Uuid().v4(),
      uid: uid,
      sourceTransactionId: sourceTransactionId,
      income: income,
      lines: lines,
    );
  }
}
