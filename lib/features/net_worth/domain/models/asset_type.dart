enum AssetType { savings, investment, property, vehicle, other }

extension AssetTypeX on AssetType {
  String get label => switch (this) {
        AssetType.savings => 'Savings',
        AssetType.investment => 'Investment',
        AssetType.property => 'Property',
        AssetType.vehicle => 'Vehicle',
        AssetType.other => 'Other',
      };

  String get iconKey => switch (this) {
        AssetType.savings => 'account_balance',
        AssetType.investment => 'trending_up',
        AssetType.property => 'home',
        AssetType.vehicle => 'directions_car',
        AssetType.other => 'category',
      };
}
