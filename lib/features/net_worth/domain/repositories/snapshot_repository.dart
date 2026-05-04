import '../models/net_worth_snapshot.dart';

abstract class SnapshotRepository {
  Stream<List<NetWorthSnapshot>> watchRecent({int limit = 12});
  Future<void> save(NetWorthSnapshot snapshot);
}
