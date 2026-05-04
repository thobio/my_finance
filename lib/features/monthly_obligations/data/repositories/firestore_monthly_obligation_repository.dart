import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/monthly_obligation.dart';
import '../../domain/models/obligation_priority.dart';
import '../../domain/repositories/monthly_obligation_repository.dart';

class FirestoreMonthlyObligationRepository
    implements MonthlyObligationRepository {
  FirestoreMonthlyObligationRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('monthly_obligations');

  static String _ym(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';

  @override
  Stream<List<MonthlyObligation>> watchByMonth(int year, int month) => _col
      .where('yearMonth', isEqualTo: _ym(year, month))
      .snapshots()
      .map((s) {
    final list = s.docs.map(_fromDoc).toList()
      ..sort((a, b) => a.dueDay.compareTo(b.dueDay));
    return list;
  });

  @override
  Future<void> add(MonthlyObligation obligation) =>
      _col.doc(obligation.id).set(_toFirestore(obligation));

  @override
  Future<void> update(MonthlyObligation obligation) =>
      _col.doc(obligation.id).update(_toFirestore(obligation));

  @override
  Future<void> delete(String id) => _col.doc(id).delete();

  MonthlyObligation _fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return MonthlyObligation(
      id: doc.id,
      uid: _uid,
      label: d['label'] as String,
      amount: (d['amount'] as num).toDouble(),
      year: d['year'] as int,
      month: d['month'] as int,
      dueDay: d['dueDay'] as int? ?? 1,
      priority: ObligationPriority.values
          .byName(d['priority'] as String? ?? 'medium'),
      isPaid: d['isPaid'] as bool? ?? false,
      notes: d['notes'] as String? ?? '',
      paidTransactionId: d['paidTransactionId'] as String?,
    );
  }

  Map<String, dynamic> _toFirestore(MonthlyObligation o) => {
        'label': o.label,
        'amount': o.amount,
        'year': o.year,
        'month': o.month,
        'yearMonth': _ym(o.year, o.month),
        'dueDay': o.dueDay,
        'priority': o.priority.name,
        'isPaid': o.isPaid,
        'notes': o.notes,
        if (o.paidTransactionId != null)
          'paidTransactionId': o.paidTransactionId,
      };
}

final monthlyObligationRepositoryProvider =
    Provider<MonthlyObligationRepository>((ref) {
  final db = FirebaseFirestore.instance;
  final uid = ref.watch(authUserProvider).valueOrNull?.uid ?? '';
  return FirestoreMonthlyObligationRepository(db, uid);
});
