import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/tax_deductions.dart';
import '../../domain/models/tax_regime.dart';
import '../../domain/models/tax_result.dart';
import '../../domain/services/tax_calculator.dart';

class TaxState {
  const TaxState({
    this.annualIncomeRupees = 0,
    this.regime = TaxRegime.newRegime,
    this.fy = '2025-26',
    this.deductions = const TaxDeductions(),
  });

  final int annualIncomeRupees;
  final TaxRegime regime;
  final String fy;
  final TaxDeductions deductions;

  TaxState copyWith({
    int? annualIncomeRupees,
    TaxRegime? regime,
    String? fy,
    TaxDeductions? deductions,
  }) =>
      TaxState(
        annualIncomeRupees: annualIncomeRupees ?? this.annualIncomeRupees,
        regime: regime ?? this.regime,
        fy: fy ?? this.fy,
        deductions: deductions ?? this.deductions,
      );
}

class TaxNotifier extends StateNotifier<TaxState> {
  TaxNotifier() : super(const TaxState());

  void setIncome(int rupees) => state = state.copyWith(annualIncomeRupees: rupees);
  void setRegime(TaxRegime regime) => state = state.copyWith(regime: regime);
  void setFy(String fy) => state = state.copyWith(fy: fy);
  void setDeductions(TaxDeductions d) => state = state.copyWith(deductions: d);
}

final taxProvider = StateNotifierProvider<TaxNotifier, TaxState>(
  (ref) => TaxNotifier(),
);

final taxResultsProvider = Provider<({TaxResult old, TaxResult newRegime})>((ref) {
  final s = ref.watch(taxProvider);
  return (
    old: TaxCalculator.compute(
      grossIncomeRupees: s.annualIncomeRupees,
      regime: TaxRegime.old,
      fy: s.fy,
      deductions: s.deductions,
    ),
    newRegime: TaxCalculator.compute(
      grossIncomeRupees: s.annualIncomeRupees,
      regime: TaxRegime.newRegime,
      fy: s.fy,
    ),
  );
});

final selectedTaxResultProvider = Provider<TaxResult>((ref) {
  final s = ref.watch(taxProvider);
  final r = ref.watch(taxResultsProvider);
  return s.regime == TaxRegime.old ? r.old : r.newRegime;
});
