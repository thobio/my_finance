import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

/// Annual budget document stored at users/{uid}/budgets/{year}
/// where year is the calendar year (e.g. 2025) or the FY start year (e.g. 2025 for FY 2025-26).
@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String uid,
    required int year,
    @Default(0.0) double totalProjectedIncome,
    /// Fixed monthly obligations: e.g. {"Rent": 15000.0, "EMI": 20000.0}
    @Default({}) Map<String, double> fixedObligations,
    /// Monthly category allocations: e.g. {"Food": 6000.0, "Travel": 2400.0}
    @Default({}) Map<String, double> monthlyAllocations,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
