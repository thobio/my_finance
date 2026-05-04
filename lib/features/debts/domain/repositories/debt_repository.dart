import '../models/debt.dart';

abstract class DebtRepository {
  Stream<List<Debt>> watchAll();
  Future<void> add(Debt debt);
  Future<void> update(Debt debt);
  Future<void> delete(String debtId);
}
