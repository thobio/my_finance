import '../models/slab_line.dart';
import '../models/tax_deductions.dart';
import '../models/tax_regime.dart';
import '../models/tax_result.dart';

class TaxCalculator {
  TaxCalculator._();

  static TaxResult compute({
    required int grossIncomeRupees,
    required TaxRegime regime,
    required String fy,
    TaxDeductions deductions = const TaxDeductions(),
  }) {
    final stdDeduction = _standardDeduction(regime, fy);
    final additionalDeductions = regime == TaxRegime.old ? deductions.total : 0;
    final taxableIncome =
        (grossIncomeRupees - stdDeduction - additionalDeductions).clamp(0, grossIncomeRupees);

    final slabs = _computeSlabs(taxableIncome, regime, fy);
    final baseTax = slabs.fold(0, (s, sl) => s + sl.taxForSlab);

    final rebateLimit = _rebateLimit(regime, fy);
    final maxRebate = _maxRebate(regime, fy);
    final rebate87A = taxableIncome <= rebateLimit ? baseTax.clamp(0, maxRebate) : 0;
    final taxAfterRebate = (baseTax - rebate87A).clamp(0, baseTax);

    final surcharge = _surcharge(grossIncomeRupees, taxAfterRebate, regime);
    final cess = ((taxAfterRebate + surcharge) * 0.04).round();
    final netTax = taxAfterRebate + surcharge + cess;

    return TaxResult(
      grossIncome: grossIncomeRupees,
      standardDeduction: stdDeduction,
      deductions: additionalDeductions,
      taxableIncome: taxableIncome,
      slabs: slabs,
      baseTax: baseTax,
      rebate87A: rebate87A,
      taxAfterRebate: taxAfterRebate,
      surcharge: surcharge,
      cess: cess,
      netTax: netTax,
      regime: regime,
      fy: fy,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static int _standardDeduction(TaxRegime regime, String fy) {
    if (regime == TaxRegime.newRegime && fy == '2025-26') return 75000;
    return 50000;
  }

  static int _rebateLimit(TaxRegime regime, String fy) {
    if (regime == TaxRegime.old) return 500000;
    if (fy == '2025-26') return 1200000;
    return 700000; // new regime FY 2024-25
  }

  static int _maxRebate(TaxRegime regime, String fy) {
    if (regime == TaxRegime.old) return 12500;
    if (fy == '2025-26') return 60000;
    return 25000; // new regime FY 2024-25
  }

  static List<SlabLine> _computeSlabs(int taxableRupees, TaxRegime regime, String fy) {
    final rawSlabs = _slabsFor(regime, fy);
    final result = <SlabLine>[];
    var remaining = taxableRupees;

    for (final s in rawSlabs) {
      if (remaining <= 0) break;
      final slabSize = s.to == null ? remaining : (s.to! - s.from);
      final taxableInSlab = remaining.clamp(0, slabSize);
      final taxForSlab = (taxableInSlab * s.rate).round();
      result.add(SlabLine(
        from: s.from,
        to: s.to,
        rate: s.rate,
        taxableInSlab: taxableInSlab,
        taxForSlab: taxForSlab,
      ));
      remaining -= taxableInSlab;
    }

    return result;
  }

  static List<_Slab> _slabsFor(TaxRegime regime, String fy) {
    if (regime == TaxRegime.old) {
      return const [
        _Slab(0, 250000, 0.0),
        _Slab(250000, 500000, 0.05),
        _Slab(500000, 1000000, 0.20),
        _Slab(1000000, null, 0.30),
      ];
    }
    if (fy == '2025-26') {
      return const [
        _Slab(0, 400000, 0.0),
        _Slab(400000, 800000, 0.05),
        _Slab(800000, 1200000, 0.10),
        _Slab(1200000, 1600000, 0.15),
        _Slab(1600000, 2000000, 0.20),
        _Slab(2000000, 2400000, 0.25),
        _Slab(2400000, null, 0.30),
      ];
    }
    // New regime FY 2024-25
    return const [
      _Slab(0, 300000, 0.0),
      _Slab(300000, 600000, 0.05),
      _Slab(600000, 900000, 0.10),
      _Slab(900000, 1200000, 0.15),
      _Slab(1200000, 1500000, 0.20),
      _Slab(1500000, null, 0.30),
    ];
  }

  static int _surcharge(int grossIncome, int taxAfterRebate, TaxRegime regime) {
    final double rate;
    if (grossIncome <= 5000000) {
      rate = 0.0;
    } else if (grossIncome <= 10000000) {
      rate = 0.10;
    } else if (grossIncome <= 20000000) {
      rate = 0.15;
    } else if (grossIncome <= 50000000) {
      rate = 0.25;
    } else {
      // New regime capped at 25%; old regime 37%
      rate = regime == TaxRegime.newRegime ? 0.25 : 0.37;
    }
    return (taxAfterRebate * rate).round();
  }
}

class _Slab {
  const _Slab(this.from, this.to, this.rate);
  final int from;
  final int? to;
  final double rate;
}
