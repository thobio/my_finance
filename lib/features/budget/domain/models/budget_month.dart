import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_month.freezed.dart';
part 'budget_month.g.dart';

/// Monthly budget snapshot stored at users/{uid}/budgets/{year}/months/{YYYY-MM}
@freezed
abstract class BudgetMonth with _$BudgetMonth {
  const factory BudgetMonth({
    required String yearMonth,
    @Default({}) Map<String, double> projected,
    @Default({}) Map<String, double> actual,
    @Default(0.0) double incomeProjected,
    @Default(0.0) double incomeActual,
  }) = _BudgetMonth;

  factory BudgetMonth.fromJson(Map<String, dynamic> json) =>
      _$BudgetMonthFromJson(json);
}
