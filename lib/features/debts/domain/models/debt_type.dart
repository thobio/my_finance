enum DebtType { loan, creditCard, bnpl }

extension DebtTypeX on DebtType {
  String get label => switch (this) {
        DebtType.loan => 'Loan',
        DebtType.creditCard => 'Credit Card',
        DebtType.bnpl => 'BNPL',
      };
}
