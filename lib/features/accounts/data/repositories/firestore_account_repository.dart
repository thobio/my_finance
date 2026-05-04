import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/account.dart';
import '../../domain/repositories/account_repository.dart';

class FirestoreAccountRepository implements AccountRepository {
  FirestoreAccountRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('accounts');

  @override
  Stream<List<Account>> watchAll() => _col
      .orderBy('createdAt')
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Future<void> add(Account account) => _col.doc(account.id).set(_toFirestore(account));

  @override
  Future<void> update(Account account) =>
      _col.doc(account.id).update(_toFirestore(account));

  @override
  Future<void> delete(String accountId) => _col.doc(accountId).delete();

  Account _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Account(
      id: doc.id,
      uid: _uid,
      name: d['name'] as String,
      type: AccountType.values.byName(d['type'] as String? ?? 'savings'),
      lastFourDigits: d['lastFourDigits'] as String?,
      institution: d['institution'] as String?,
      openingBalance: (d['openingBalance'] as num?)?.toDouble() ?? 0.0,
      creditLimit: (d['creditLimit'] as num?)?.toDouble(),
      isActive: d['isActive'] as bool? ?? true,
      createdAt: (d['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _toFirestore(Account a) => {
        'name': a.name,
        'type': a.type.name,
        if (a.lastFourDigits != null) 'lastFourDigits': a.lastFourDigits,
        if (a.institution != null) 'institution': a.institution,
        'openingBalance': a.openingBalance,
        if (a.creditLimit != null) 'creditLimit': a.creditLimit,
        'isActive': a.isActive,
        'createdAt': Timestamp.fromDate(a.createdAt),
      };
}

// ── Provider ──────────────────────────────────────────────────────────────────

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final db = FirebaseFirestore.instance;
  final uid = ref.watch(authUserProvider).valueOrNull?.uid ?? '';
  return FirestoreAccountRepository(db, uid);
});
