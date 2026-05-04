import '../models/distribution.dart';

abstract class DistributionRepository {
  Stream<List<Distribution>> watchDistributions(String uid);
  Stream<Distribution?> watchDistribution(String uid, String distributionId);
  Future<void> saveDistribution(String uid, Distribution distribution);
  Future<void> acceptDistribution(String uid, String distributionId);
}
