import '../models/debt.dart';
import '../models/payoff_result.dart';
import '../models/payoff_strategy.dart';

class PayoffCalculator {
  static PayoffResult compute({
    required List<Debt> debts,
    required double monthlyBudget,
    required PayoffStrategy strategy,
  }) {
    if (debts.isEmpty || monthlyBudget <= 0) {
      return const PayoffResult(months: 0, totalInterest: 0.0, payoffOrder: []);
    }

    final balances = {for (final d in debts) d.id: d.outstanding};
    double totalInterest = 0;
    final payoffOrder = <String>[];
    var active = debts.toList();
    int months = 0;

    while (active.isNotEmpty && months < 600) {
      months++;
      double budget = monthlyBudget;

      // Accrue monthly interest
      for (final d in active) {
        final rate = d.interestRatePercent / 100 / 12;
        final interest = balances[d.id]! * rate;
        balances[d.id] = balances[d.id]! + interest;
        totalInterest += interest;
      }

      // Sort by strategy
      final sorted = List<Debt>.from(active);
      if (strategy == PayoffStrategy.avalanche) {
        sorted.sort((a, b) => b.interestRatePercent.compareTo(a.interestRatePercent));
      } else {
        sorted.sort((a, b) => balances[a.id]!.compareTo(balances[b.id]!));
      }

      // Pay minimums
      for (final d in sorted) {
        if (budget <= 0) break;
        final bal = balances[d.id]!;
        final pmt = [d.minimumPayment, bal, budget].reduce(
          (a, b) => a < b ? a : b,
        );
        balances[d.id] = bal - pmt;
        budget -= pmt;
      }

      // Apply extra to priority debt
      for (final d in sorted) {
        if (budget <= 0) break;
        final bal = balances[d.id]!;
        if (bal > 0) {
          final pmt = bal < budget ? bal : budget;
          balances[d.id] = bal - pmt;
          budget -= pmt;
        }
      }

      // Detect paid-off debts (≤ 1 paise threshold for floating point)
      final justPaid = active.where((d) => balances[d.id]! <= 1).toList();
      for (final d in justPaid) {
        payoffOrder.add(d.label);
      }
      active = active.where((d) => balances[d.id]! > 1).toList();
    }

    return PayoffResult(
      months: months,
      totalInterest: totalInterest,
      payoffOrder: payoffOrder,
    );
  }
}
