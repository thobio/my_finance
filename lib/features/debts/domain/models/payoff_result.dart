class PayoffResult {
  const PayoffResult({
    required this.months,
    required this.totalInterest,
    required this.payoffOrder,
  });

  final int months;
  final double totalInterest;
  final List<String> payoffOrder;

  String get monthsLabel {
    if (months == 0) return 'Already paid off';
    final y = months ~/ 12;
    final m = months % 12;
    if (y == 0) return '$m mo';
    if (m == 0) return '$y yr';
    return '$y yr $m mo';
  }
}
