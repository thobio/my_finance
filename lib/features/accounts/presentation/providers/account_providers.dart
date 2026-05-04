import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../transactions/domain/models/transaction_type.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../data/repositories/firestore_account_repository.dart';
import '../../domain/models/account.dart';

// ── Streams ───────────────────────────────────────────────────────────────────

final accountsProvider = StreamProvider<List<Account>>((ref) {
  final user = ref.watch(authUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final repo = ref.watch(accountRepositoryProvider);
  return repo.watchAll();
});

// ── Live balance per account ──────────────────────────────────────────────────

final accountBalanceProvider = Provider.family<double, Account>((ref, account) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final accountTxns = txns.where((t) => t.accountId == account.id);

  final income = accountTxns
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (s, t) => s + t.amount);
  final expense = accountTxns
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (s, t) => s + t.amount);

  return account.openingBalance + income - expense;
});

// ── Total balance across all active accounts ──────────────────────────────────

final totalBalanceProvider = Provider<double>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? [];
  return accounts
      .where((a) => a.isActive && a.type != AccountType.creditCard && a.type != AccountType.loan)
      .fold(0.0, (s, a) => s + ref.watch(accountBalanceProvider(a)));
});

// ── Hide balances toggle ──────────────────────────────────────────────────────

final hideBalancesProvider = StateProvider<bool>((ref) => false);

// ── Controller ────────────────────────────────────────────────────────────────

final accountControllerProvider =
    StateNotifierProvider<AccountController, AsyncValue<void>>(
  AccountController.new,
);

class AccountController extends StateNotifier<AsyncValue<void>> {
  AccountController(this._ref) : super(const AsyncData(null));

  final Ref _ref;
  final _uuid = const Uuid();

  Future<void> add({
    required String name,
    required AccountType type,
    String? lastFourDigits,
    String? institution,
    double openingBalance = 0.0,
    double? creditLimit,
  }) async {
    state = const AsyncLoading();
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    final account = Account(
      id: _uuid.v4(),
      uid: uid,
      name: name,
      type: type,
      lastFourDigits: lastFourDigits,
      institution: institution,
      openingBalance: openingBalance,
      creditLimit: creditLimit,
      createdAt: DateTime.now(),
    );
    state = await AsyncValue.guard(
        () => _ref.read(accountRepositoryProvider).add(account));
  }

  Future<void> update(Account account) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _ref.read(accountRepositoryProvider).update(account));
  }

  Future<void> delete(String accountId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _ref.read(accountRepositoryProvider).delete(accountId));
  }
}
