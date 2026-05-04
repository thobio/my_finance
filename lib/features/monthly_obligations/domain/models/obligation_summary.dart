import 'monthly_obligation.dart';

class ObligationPayStep {
  const ObligationPayStep({
    required this.obligation,
    required this.balanceAfter,
    required this.canAfford,
  });

  final MonthlyObligation obligation;
  final double balanceAfter;
  final bool canAfford;
}

class ObligationSummary {
  const ObligationSummary({
    required this.totalIncome,
    required this.obligations,
  });

  final double totalIncome;
  final List<MonthlyObligation> obligations;

  double get totalObligations =>
      obligations.fold(0.0, (s, o) => s + o.amount);

  double get paidAmount =>
      obligations.where((o) => o.isPaid).fold(0.0, (s, o) => s + o.amount);

  double get unpaidAmount =>
      obligations.where((o) => !o.isPaid).fold(0.0, (s, o) => s + o.amount);

  double get surplus => totalIncome - totalObligations;

  List<MonthlyObligation> get unpaidByPriority {
    final unpaid = obligations.where((o) => !o.isPaid).toList();
    unpaid.sort((a, b) {
      final pc = a.priority.sortOrder.compareTo(b.priority.sortOrder);
      return pc != 0 ? pc : a.dueDay.compareTo(b.dueDay);
    });
    return unpaid;
  }

  List<ObligationPayStep> get payPlan {
    final steps = <ObligationPayStep>[];
    var balance = totalIncome;
    for (final o in unpaidByPriority) {
      final canAfford = balance >= o.amount;
      balance -= o.amount;
      steps.add(ObligationPayStep(
        obligation: o,
        balanceAfter: balance,
        canAfford: canAfford,
      ));
    }
    return steps;
  }
}
