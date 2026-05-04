import '../models/monthly_obligation.dart';

abstract class MonthlyObligationRepository {
  Stream<List<MonthlyObligation>> watchByMonth(int year, int month);
  Future<void> add(MonthlyObligation obligation);
  Future<void> update(MonthlyObligation obligation);
  Future<void> delete(String id);
}
