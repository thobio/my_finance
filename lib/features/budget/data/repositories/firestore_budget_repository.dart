import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/budget.dart';
import '../../domain/models/budget_month.dart';
import '../../domain/repositories/budget_repository.dart';

class FirestoreBudgetRepository implements BudgetRepository {
  FirestoreBudgetRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _budgetsCol(String uid) =>
      _db.collection('users').doc(uid).collection('budgets');

  @override
  Stream<Budget?> watchBudget(String uid, int year) {
    return _budgetsCol(uid).doc(year.toString()).snapshots().map((snap) {
      if (!snap.exists) return null;
      final data = snap.data()!;
      return Budget(
        id: snap.id,
        uid: uid,
        year: year,
        totalProjectedIncome: (data['totalProjectedIncome'] as num?)?.toDouble() ?? 0.0,
        fixedObligations: _toDoubleMap(data['fixedObligations']),
        monthlyAllocations: _toDoubleMap(data['monthlyAllocations']),
      );
    });
  }

  @override
  Future<void> saveBudget(Budget budget) async {
    await _budgetsCol(budget.uid).doc(budget.year.toString()).set({
      'uid': budget.uid,
      'year': budget.year,
      'totalProjectedIncome': budget.totalProjectedIncome,
      'fixedObligations': budget.fixedObligations,
      'monthlyAllocations': budget.monthlyAllocations,
    });
  }

  @override
  Stream<List<BudgetMonth>> watchMonths(String uid, int year) {
    return _budgetsCol(uid)
        .doc(year.toString())
        .collection('months')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final d = doc.data();
              return BudgetMonth(
                yearMonth: doc.id,
                projected: _toDoubleMap(d['projected']),
                actual: _toDoubleMap(d['actual']),
                incomeProjected: (d['incomeProjected'] as num?)?.toDouble() ?? 0.0,
                incomeActual: (d['incomeActual'] as num?)?.toDouble() ?? 0.0,
              );
            }).toList());
  }

  @override
  Future<void> saveMonth(String uid, int year, BudgetMonth month) async {
    await _budgetsCol(uid)
        .doc(year.toString())
        .collection('months')
        .doc(month.yearMonth)
        .set({
      'yearMonth': month.yearMonth,
      'projected': month.projected,
      'actual': month.actual,
      'incomeProjected': month.incomeProjected,
      'incomeActual': month.incomeActual,
    });
  }

  Map<String, double> _toDoubleMap(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), (v as num).toDouble()));
    }
    return {};
  }
}

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => FirestoreBudgetRepository(FirebaseFirestore.instance),
);
