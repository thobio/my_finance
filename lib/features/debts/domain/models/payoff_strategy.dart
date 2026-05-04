enum PayoffStrategy { avalanche, snowball }

extension PayoffStrategyX on PayoffStrategy {
  String get label => switch (this) {
        PayoffStrategy.avalanche => 'Avalanche',
        PayoffStrategy.snowball => 'Snowball',
      };

  String get description => switch (this) {
        PayoffStrategy.avalanche => 'Highest interest first — saves the most money',
        PayoffStrategy.snowball => 'Lowest balance first — faster early wins',
      };
}
