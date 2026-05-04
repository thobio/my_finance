import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_type.dart';
import '../../domain/repositories/debt_repository.dart';

class FirestoreDebtRepository implements DebtRepository {
  FirestoreDebtRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _debts =>
      _db.collection('users').doc(_uid).collection('debts');

  @override
  Stream<List<Debt>> watchAll() => _debts
      .orderBy('label')
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Future<void> add(Debt debt) => _debts.doc(debt.id).set(_toFirestore(debt));

  @override
  Future<void> update(Debt debt) =>
      _debts.doc(debt.id).update(_toFirestore(debt));

  @override
  Future<void> delete(String debtId) => _debts.doc(debtId).delete();

  // ── Mapping ───────────────────────────────────────────────────────────────

  Debt _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Debt(
      id: doc.id,
      uid: _uid,
      label: d['label'] as String,
      type: DebtType.values.byName(d['type'] as String? ?? 'loan'),
      outstanding: (d['outstanding'] as num?)?.toDouble() ?? 0.0,
      interestRatePercent: (d['interestRatePercent'] as num?)?.toDouble() ?? 0.0,
      minimumPayment: (d['minimumPayment'] as num?)?.toDouble() ?? 0.0,
      dueDay: d['dueDay'] as int? ?? 1,
      linkedAccountId: d['linkedAccountId'] as String?,
      creditLimit: (d['creditLimit'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> _toFirestore(Debt debt) => {
        'label': debt.label,
        'type': debt.type.name,
        'outstanding': debt.outstanding,
        'interestRatePercent': debt.interestRatePercent,
        'minimumPayment': debt.minimumPayment,
        'dueDay': debt.dueDay,
        if (debt.linkedAccountId != null) 'linkedAccountId': debt.linkedAccountId,
        if (debt.creditLimit != null) 'creditLimit': debt.creditLimit,
      };
}

// ── Provider ──────────────────────────────────────────────────────────────────

final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final db = FirebaseFirestore.instance;
  final uid = ref.watch(authUserProvider).valueOrNull?.uid ?? '';
  return FirestoreDebtRepository(db, uid);
});
