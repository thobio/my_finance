class TaxDeductions {
  const TaxDeductions({
    this.section80C = 0,
    this.section80D = 0,
    this.hra = 0,
    this.homeLoanInterest = 0,
    this.nps80CCD1B = 0,
    this.otherDeductions = 0,
  });

  final int section80C;       // capped at ₹1,50,000
  final int section80D;
  final int hra;
  final int homeLoanInterest; // capped at ₹2,00,000
  final int nps80CCD1B;       // capped at ₹50,000
  final int otherDeductions;

  int get total =>
      section80C.clamp(0, 150000) +
      section80D +
      hra +
      homeLoanInterest.clamp(0, 200000) +
      nps80CCD1B.clamp(0, 50000) +
      otherDeductions;

  TaxDeductions copyWith({
    int? section80C,
    int? section80D,
    int? hra,
    int? homeLoanInterest,
    int? nps80CCD1B,
    int? otherDeductions,
  }) =>
      TaxDeductions(
        section80C: section80C ?? this.section80C,
        section80D: section80D ?? this.section80D,
        hra: hra ?? this.hra,
        homeLoanInterest: homeLoanInterest ?? this.homeLoanInterest,
        nps80CCD1B: nps80CCD1B ?? this.nps80CCD1B,
        otherDeductions: otherDeductions ?? this.otherDeductions,
      );
}
