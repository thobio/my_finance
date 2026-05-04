import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/asset_type.dart';
import '../../domain/repositories/asset_repository.dart';

class FirestoreAssetRepository implements AssetRepository {
  FirestoreAssetRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _assets =>
      _db.collection('users').doc(_uid).collection('assets');

  @override
  Stream<List<Asset>> watchAll() => _assets
      .orderBy('label')
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Future<void> add(Asset asset) => _assets.doc(asset.id).set(_toFirestore(asset));

  @override
  Future<void> update(Asset asset) =>
      _assets.doc(asset.id).update(_toFirestore(asset));

  @override
  Future<void> delete(String assetId) => _assets.doc(assetId).delete();

  Asset _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Asset(
      id: doc.id,
      uid: _uid,
      label: d['label'] as String,
      type: AssetType.values.byName(d['type'] as String? ?? 'savings'),
      value: (d['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> _toFirestore(Asset a) => {
        'label': a.label,
        'type': a.type.name,
        'value': a.value,
      };
}

// ── Provider ──────────────────────────────────────────────────────────────────

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  final db = FirebaseFirestore.instance;
  final uid = ref.watch(authUserProvider).valueOrNull?.uid ?? '';
  return FirestoreAssetRepository(db, uid);
});
