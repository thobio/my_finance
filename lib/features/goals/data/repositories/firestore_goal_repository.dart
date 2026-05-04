import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/goal_contribution.dart';
import '../../domain/models/goal_status.dart';
import '../../domain/models/goal_type.dart';
import '../../domain/repositories/goal_repository.dart';

class FirestoreGoalRepository implements GoalRepository {
  FirestoreGoalRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _goals =>
      _db.collection('users').doc(_uid).collection('goals');

  DocumentReference<Map<String, dynamic>> _goalDoc(String id) =>
      _goals.doc(id);

  CollectionReference<Map<String, dynamic>> _contributions(String goalId) =>
      _goalDoc(goalId).collection('contributions');

  @override
  Stream<List<Goal>> watchAll() => _goals
      .orderBy('priority')
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Future<void> add(Goal goal) => _goalDoc(goal.id).set(_toFirestore(goal));

  @override
  Future<void> update(Goal goal) =>
      _goalDoc(goal.id).update(_toFirestore(goal));

  @override
  Future<void> delete(String goalId) => _goalDoc(goalId).delete();

  @override
  Stream<List<GoalContribution>> watchContributions(String goalId) =>
      _contributions(goalId)
          .orderBy('contributedAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(_fromContribDoc).toList());

  @override
  Future<void> addContribution(GoalContribution contribution) =>
      _contributions(contribution.goalId)
          .doc(contribution.id)
          .set(_toContribFirestore(contribution));

  @override
  Future<void> deleteContribution(
          String goalId, String contributionId) =>
      _contributions(goalId).doc(contributionId).delete();

  @override
  Future<void> updateSavedAmount(String goalId, double newSaved) =>
      _goalDoc(goalId).update({'currentSaved': newSaved});

  // ── Mapping ──────────────────────────────────────────────────────────────

  Goal _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Goal(
      id: doc.id,
      uid: _uid,
      name: d['name'] as String,
      targetAmount: (d['targetAmount'] as num?)?.toDouble() ?? 0.0,
      targetDate: (d['targetDate'] as Timestamp).toDate(),
      startDate: (d['startDate'] as Timestamp).toDate(),
      currentSaved: (d['currentSaved'] as num?)?.toDouble() ?? 0.0,
      monthlyContribution: (d['monthlyContribution'] as num?)?.toDouble() ?? 0.0,
      priority: d['priority'] as int? ?? 1,
      status: GoalStatus.values.byName(d['status'] as String? ?? 'active'),
      type: GoalType.values.byName(d['type'] as String? ?? 'standard'),
    );
  }

  Map<String, dynamic> _toFirestore(Goal g) => {
        'name': g.name,
        'targetAmount': g.targetAmount,
        'targetDate': Timestamp.fromDate(g.targetDate),
        'startDate': Timestamp.fromDate(g.startDate),
        'currentSaved': g.currentSaved,
        'monthlyContribution': g.monthlyContribution,
        'priority': g.priority,
        'status': g.status.name,
        'type': g.type.name,
      };

  GoalContribution _fromContribDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return GoalContribution(
      id: doc.id,
      goalId: doc.reference.parent.parent!.id,
      amount: (d['amount'] as num?)?.toDouble() ?? 0.0,
      contributedAt: (d['contributedAt'] as Timestamp).toDate(),
      sourceTransactionId: d['sourceTransactionId'] as String?,
      note: d['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> _toContribFirestore(GoalContribution c) => {
        'amount': c.amount,
        'contributedAt': Timestamp.fromDate(c.contributedAt),
        if (c.sourceTransactionId != null)
          'sourceTransactionId': c.sourceTransactionId,
        'note': c.note,
      };
}

// ── Provider ─────────────────────────────────────────────────────────────────

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final db = FirebaseFirestore.instance;
  final uid = ref.watch(authUserProvider).valueOrNull?.uid ?? '';
  return FirestoreGoalRepository(db, uid);
});
