import 'package:cloud_firestore/cloud_firestore.dart'
    hide Transaction; // avoid name clash with our domain Transaction

import '../../domain/models/transaction.dart';
import '../../domain/models/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';

class FirestoreTransactionRepository implements TransactionRepository {
  FirestoreTransactionRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('transactions');

  @override
  Stream<List<Transaction>> watchAll(String uid) {
    return _col(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(_mapDocs);
  }

  @override
  Stream<List<Transaction>> watchByAccount(String uid, String accountId) {
    return _col(uid)
        .where('accountId', isEqualTo: accountId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(_mapDocs);
  }

  @override
  Future<Transaction> add(String uid, Transaction transaction) async {
    final ref = _col(uid).doc(transaction.id);
    await ref.set(_toFirestore(transaction));
    return transaction;
  }

  @override
  Future<void> update(String uid, Transaction transaction) {
    return _col(uid).doc(transaction.id).update(_toFirestore(transaction));
  }

  @override
  Future<void> delete(String uid, String transactionId) {
    return _col(uid).doc(transactionId).delete();
  }

  @override
  Future<bool> hashExists(String uid, String deduplicationHash) async {
    final snap = await _col(uid)
        .where('deduplicationHash', isEqualTo: deduplicationHash)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  @override
  Future<void> addBatch(String uid, List<Transaction> transactions) async {
    final batches = <WriteBatch>[];
    var batch = _db.batch();
    var count = 0;

    for (final txn in transactions) {
      batch.set(_col(uid).doc(txn.id), _toFirestore(txn));
      count++;
      if (count == 500) {
        batches.add(batch);
        batch = _db.batch();
        count = 0;
      }
    }
    if (count > 0) batches.add(batch);

    await Future.wait(batches.map((b) => b.commit()));
  }

  @override
  Future<List<Transaction>> getByDateRange(
    String uid,
    DateTime from,
    DateTime to, {
    TransactionType? type,
  }) async {
    var query = _col(uid)
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(from),
            isLessThanOrEqualTo: Timestamp.fromDate(to))
        .orderBy('date', descending: true);

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    final snap = await query.get();
    return _mapDocs(snap);
  }

  List<Transaction> _mapDocs(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      if (data['date'] is Timestamp) {
        data['date'] = (data['date'] as Timestamp).toDate().toIso8601String();
      }
      return Transaction.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> _toFirestore(Transaction txn) {
    final json = txn.toJson();
    json['date'] = Timestamp.fromDate(txn.date);
    return json;
  }
}
