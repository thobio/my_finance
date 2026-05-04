import 'slab_line.dart';
import 'tax_regime.dart';

class TaxResult {
  const TaxResult({
    required this.grossIncome,
    required this.standardDeduction,
    required this.deductions,
    required this.taxableIncome,
    required this.slabs,
    required this.baseTax,
    required this.rebate87A,
    required this.taxAfterRebate,
    required this.surcharge,
    required this.cess,
    required this.netTax,
    required this.regime,
    required this.fy,
  });

  final int grossIncome;       // rupees
  final int standardDeduction; // rupees
  final int deductions;        // rupees (0 for new regime)
  final int taxableIncome;     // rupees
  final List<SlabLine> slabs;
  final int baseTax;
  final int rebate87A;
  final int taxAfterRebate;
  final int surcharge;
  final int cess;
  final int netTax;
  final TaxRegime regime;
  final String fy;

  double get effectiveRate => grossIncome > 0 ? netTax / grossIncome : 0.0;
  int get monthlyTds => (netTax / 12).round();
}
