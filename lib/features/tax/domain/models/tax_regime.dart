enum TaxRegime { old, newRegime }

extension TaxRegimeX on TaxRegime {
  String get label => this == TaxRegime.old ? 'Old Regime' : 'New Regime';
}
