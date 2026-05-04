enum ObligationPriority {
  high,
  medium,
  low;

  String get label => switch (this) {
        ObligationPriority.high => 'High',
        ObligationPriority.medium => 'Medium',
        ObligationPriority.low => 'Low',
      };

  int get sortOrder => switch (this) {
        ObligationPriority.high => 0,
        ObligationPriority.medium => 1,
        ObligationPriority.low => 2,
      };
}
