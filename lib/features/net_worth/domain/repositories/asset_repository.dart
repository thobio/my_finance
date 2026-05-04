import '../models/asset.dart';

abstract class AssetRepository {
  Stream<List<Asset>> watchAll();
  Future<void> add(Asset asset);
  Future<void> update(Asset asset);
  Future<void> delete(String assetId);
}
