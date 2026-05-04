import '../models/transaction.dart';
import '../models/transaction_type.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> watchAll(String uid);
  Stream<List<Transaction>> watchByAccount(String uid, String accountId);
  Future<Transaction> add(String uid, Transaction transaction);
  Future<void> update(String uid, Transaction transaction);
  Future<void> delete(String uid, String transactionId);
  Future<bool> hashExists(String uid, String deduplicationHash);
  Future<void> addBatch(String uid, List<Transaction> transactions);
  Future<List<Transaction>> getByDateRange(
    String uid,
    DateTime from,
    DateTime to, {
    TransactionType? type,
  });
}
