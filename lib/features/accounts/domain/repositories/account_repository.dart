import '../models/account.dart';

abstract class AccountRepository {
  Stream<List<Account>> watchAll();
  Future<void> add(Account account);
  Future<void> update(Account account);
  Future<void> delete(String accountId);
}
