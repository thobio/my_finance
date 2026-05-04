enum RecurrenceFrequency {
  daily,
  weekly,
  biweekly,
  monthly,
  everyTwoMonths,
  quarterly,
  yearly,
}

extension RecurrenceFrequencyLabel on RecurrenceFrequency {
  String get label => switch (this) {
        RecurrenceFrequency.daily => 'Daily',
        RecurrenceFrequency.weekly => 'Weekly',
        RecurrenceFrequency.biweekly => 'Every 2 weeks',
        RecurrenceFrequency.monthly => 'Monthly',
        RecurrenceFrequency.everyTwoMonths => 'Every 2 months',
        RecurrenceFrequency.quarterly => 'Quarterly (3 months)',
        RecurrenceFrequency.yearly => 'Yearly',
      };

  /// Returns the next due date after [from] based on this frequency.
  DateTime nextAfter(DateTime from) => switch (this) {
        RecurrenceFrequency.daily => from.add(const Duration(days: 1)),
        RecurrenceFrequency.weekly => from.add(const Duration(days: 7)),
        RecurrenceFrequency.biweekly => from.add(const Duration(days: 14)),
        RecurrenceFrequency.monthly =>
          DateTime(from.year, from.month + 1, from.day),
        RecurrenceFrequency.everyTwoMonths =>
          DateTime(from.year, from.month + 2, from.day),
        RecurrenceFrequency.quarterly =>
          DateTime(from.year, from.month + 3, from.day),
        RecurrenceFrequency.yearly =>
          DateTime(from.year + 1, from.month, from.day),
      };
}
