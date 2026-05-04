import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/wish_item.dart';
import '../../domain/models/wish_item_status.dart';
import '../../domain/repositories/wish_item_repository.dart';

class FirestoreWishItemRepository implements WishItemRepository {
  FirestoreWishItemRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('wishlist');

  @override
  Stream<List<WishItem>> watchAll() => _col
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Future<void> add(WishItem item) => _col.doc(item.id).set(_toFirestore(item));

  @override
  Future<void> update(WishItem item) =>
      _col.doc(item.id).update(_toFirestore(item));

  @override
  Future<void> delete(String id) => _col.doc(id).delete();

  // ── Mapping ─────────────────────────────────────────────────────────────────

  WishItem _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return WishItem(
      id: doc.id,
      uid: _uid,
      name: d['name'] as String,
      estimatedCost: (d['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      desiredMonth: (d['desiredMonth'] as Timestamp).toDate(),
      linkedGoalId: d['linkedGoalId'] as String?,
      status: WishItemStatus.values.byName(
          d['status'] as String? ?? 'pending'),
      createdAt: (d['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _toFirestore(WishItem w) => {
        'name': w.name,
        'estimatedCost': w.estimatedCost,
        'desiredMonth': Timestamp.fromDate(w.desiredMonth),
        if (w.linkedGoalId != null) 'linkedGoalId': w.linkedGoalId,
        'status': w.status.name,
        'createdAt': Timestamp.fromDate(w.createdAt),
      };
}

// ── Provider ──────────────────────────────────────────────────────────────────

final wishItemRepositoryProvider = Provider<WishItemRepository>((ref) {
  final uid = ref.watch(authUserProvider).valueOrNull?.uid ?? '';
  return FirestoreWishItemRepository(FirebaseFirestore.instance, uid);
});
