import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/distribution.dart';
import '../../domain/models/distribution_line.dart';
import '../../domain/repositories/distribution_repository.dart';

class FirestoreDistributionRepository implements DistributionRepository {
  FirestoreDistributionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection('users').doc(uid).collection('distributions');

  @override
  Stream<List<Distribution>> watchDistributions(String uid) {
    return _col(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => _fromDoc(d.id, d.data())).toList());
  }

  @override
  Stream<Distribution?> watchDistribution(String uid, String distributionId) {
    return _col(uid).doc(distributionId).snapshots().map((s) {
      if (!s.exists || s.data() == null) return null;
      return _fromDoc(s.id, s.data()!);
    });
  }

  @override
  Future<void> saveDistribution(String uid, Distribution distribution) async {
    await _col(uid).doc(distribution.id).set(_toMap(distribution));
  }

  @override
  Future<void> acceptDistribution(
      String uid, String distributionId) async {
    await _col(uid).doc(distributionId).update({'accepted': true});
  }

  Distribution _fromDoc(String id, Map<String, dynamic> data) {
    final rawLines = data['lines'] as List<dynamic>? ?? [];
    final lines = rawLines.map((l) {
      final m = Map<String, dynamic>.from(l as Map);
      return DistributionLine(
        label: m['label'] as String,
        amount: (m['amount'] as num?)?.toDouble() ?? 0.0,
        type: DistributionLineType.values.byName(m['type'] as String),
        goalId: m['goalId'] as String?,
        categoryId: m['categoryId'] as String?,
      );
    }).toList();

    return Distribution(
      id: id,
      uid: data['uid'] as String,
      sourceTransactionId: data['sourceTransactionId'] as String,
      income: (data['income'] as num?)?.toDouble() ?? 0.0,
      lines: lines,
      accepted: (data['accepted'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> _toMap(Distribution d) {
    return {
      'uid': d.uid,
      'sourceTransactionId': d.sourceTransactionId,
      'income': d.income,
      'accepted': d.accepted,
      'lines': d.lines
          .map((l) => {
                'label': l.label,
                'amount': l.amount,
                'type': l.type.name,
                if (l.goalId != null) 'goalId': l.goalId,
                if (l.categoryId != null) 'categoryId': l.categoryId,
              })
          .toList(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

final distributionRepositoryProvider =
    Provider<DistributionRepository>((ref) {
  return FirestoreDistributionRepository(FirebaseFirestore.instance);
});
