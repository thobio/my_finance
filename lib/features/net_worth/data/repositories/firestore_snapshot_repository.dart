import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/net_worth_snapshot.dart';
import '../../domain/repositories/snapshot_repository.dart';

class FirestoreSnapshotRepository implements SnapshotRepository {
  FirestoreSnapshotRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _snapshots =>
      _db.collection('users').doc(_uid).collection('netWorthSnapshots');

  @override
  Stream<List<NetWorthSnapshot>> watchRecent({int limit = 12}) => _snapshots
      .orderBy('capturedAt', descending: true)
      .limit(limit)
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList()..sort(
            (a, b) => a.capturedAt.compareTo(b.capturedAt),
          ));

  @override
  Future<void> save(NetWorthSnapshot snapshot) =>
      _snapshots.doc(snapshot.id).set(_toFirestore(snapshot));

  NetWorthSnapshot _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return NetWorthSnapshot(
      id: doc.id,
      uid: _uid,
      totalAssets: (d['totalAssets'] as num?)?.toDouble() ?? 0.0,
      totalLiabilities: (d['totalLiabilities'] as num?)?.toDouble() ?? 0.0,
      netWorth: (d['netWorth'] as num?)?.toDouble() ?? 0.0,
      capturedAt: (d['capturedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _toFirestore(NetWorthSnapshot s) => {
        'totalAssets': s.totalAssets,
        'totalLiabilities': s.totalLiabilities,
        'netWorth': s.netWorth,
        'capturedAt': Timestamp.fromDate(s.capturedAt),
      };
}

// ── Provider ──────────────────────────────────────────────────────────────────

final snapshotRepositoryProvider = Provider<SnapshotRepository>((ref) {
  final db = FirebaseFirestore.instance;
  final uid = ref.watch(authUserProvider).valueOrNull?.uid ?? '';
  return FirestoreSnapshotRepository(db, uid);
});
