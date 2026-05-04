import '../models/budget.dart';
import '../models/budget_month.dart';

abstract class BudgetRepository {
  Stream<Budget?> watchBudget(String uid, int year);
  Future<void> saveBudget(Budget budget);
  Stream<List<BudgetMonth>> watchMonths(String uid, int year);
  Future<void> saveMonth(String uid, int year, BudgetMonth month);
}
