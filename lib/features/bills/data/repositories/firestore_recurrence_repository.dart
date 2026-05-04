import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/recurrence.dart';
import '../../domain/models/recurrence_frequency.dart';
import '../../domain/repositories/recurrence_repository.dart';

class FirestoreRecurrenceRepository implements RecurrenceRepository {
  FirestoreRecurrenceRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection('users').doc(uid).collection('recurrences');

  @override
  Stream<List<Recurrence>> watchAll(String uid) {
    return _col(uid)
        .orderBy('nextDueDate')
        .snapshots()
        .map((s) => s.docs
            .map((d) => _fromDoc(d.id, d.data()))
            .where((r) => r.isActive)
            .toList());
  }

  @override
  Future<void> add(Recurrence recurrence) async {
    await _col(recurrence.uid).doc(recurrence.id).set(_toMap(recurrence));
  }

  @override
  Future<void> update(Recurrence recurrence) async {
    await _col(recurrence.uid).doc(recurrence.id).set(_toMap(recurrence));
  }

  @override
  Future<void> delete(String uid, String recurrenceId) async {
    await _col(uid).doc(recurrenceId).update({'isActive': false});
  }

  @override
  Future<void> markPaid(
      String uid, String recurrenceId, DateTime paidDate) async {
    final doc = await _col(uid).doc(recurrenceId).get();
    if (!doc.exists) return;
    final recurrence = _fromDoc(doc.id, doc.data()!);
    final next = recurrence.frequency.nextAfter(recurrence.nextDueDate);
    await _col(uid).doc(recurrenceId).update({
      'lastPaidDate': Timestamp.fromDate(paidDate),
      'nextDueDate': Timestamp.fromDate(next),
    });
  }

  Recurrence _fromDoc(String id, Map<String, dynamic> data) {
    DateTime ts(String key) => (data[key] as Timestamp).toDate();
    DateTime? tsOpt(String key) =>
        data[key] == null ? null : (data[key] as Timestamp).toDate();

    return Recurrence(
      id: id,
      uid: data['uid'] as String,
      label: data['label'] as String,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      categoryId: data['categoryId'] as String,
      frequency:
          RecurrenceFrequency.values.byName(data['frequency'] as String),
      dayOfMonth: (data['dayOfMonth'] as int?) ?? 1,
      startDate: ts('startDate'),
      endDate: tsOpt('endDate'),
      nextDueDate: ts('nextDueDate'),
      lastPaidDate: tsOpt('lastPaidDate'),
      isActive: (data['isActive'] as bool?) ?? true,
      autoPost: (data['autoPost'] as bool?) ?? false,
      reminderOffsetDays: (data['reminderOffsetDays'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> _toMap(Recurrence r) {
    return {
      'uid': r.uid,
      'label': r.label,
      'amount': r.amount,
      'categoryId': r.categoryId,
      'frequency': r.frequency.name,
      'dayOfMonth': r.dayOfMonth,
      'startDate': Timestamp.fromDate(r.startDate),
      if (r.endDate != null) 'endDate': Timestamp.fromDate(r.endDate!),
      'nextDueDate': Timestamp.fromDate(r.nextDueDate),
      if (r.lastPaidDate != null)
        'lastPaidDate': Timestamp.fromDate(r.lastPaidDate!),
      'isActive': r.isActive,
      'autoPost': r.autoPost,
      'reminderOffsetDays': r.reminderOffsetDays,
    };
  }
}

final recurrenceRepositoryProvider = Provider<RecurrenceRepository>((ref) {
  return FirestoreRecurrenceRepository(FirebaseFirestore.instance);
});
