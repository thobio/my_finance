class HealthPillars {
  const HealthPillars({
    required this.savingsScore,
    required this.debtScore,
    required this.goalsScore,
    required this.emergencyScore,
    required this.billsScore,
    this.hasData = true,
  });

  const HealthPillars.empty()
      : savingsScore = 0,
        debtScore = 0,
        goalsScore = 0,
        emergencyScore = 0,
        billsScore = 0,
        hasData = false;

  final int savingsScore;   // 0–25
  final int debtScore;      // 0–25
  final int goalsScore;     // 0–20
  final int emergencyScore; // 0–20
  final int billsScore;     // 0–10
  final bool hasData;

  int get total =>
      savingsScore + debtScore + goalsScore + emergencyScore + billsScore;

  static const labels = ['Savings', 'Debt', 'Goals', 'Emergency', 'Bills'];
  static const maxScores = [25, 25, 20, 20, 10];

  List<int> get scores =>
      [savingsScore, debtScore, goalsScore, emergencyScore, billsScore];
}
