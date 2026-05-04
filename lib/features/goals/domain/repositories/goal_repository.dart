import '../models/goal.dart';
import '../models/goal_contribution.dart';

abstract class GoalRepository {
  Stream<List<Goal>> watchAll();
  Future<void> add(Goal goal);
  Future<void> update(Goal goal);
  Future<void> delete(String goalId);

  Stream<List<GoalContribution>> watchContributions(String goalId);
  Future<void> addContribution(GoalContribution contribution);
  Future<void> deleteContribution(String goalId, String contributionId);
  Future<void> updateSavedAmount(String goalId, double newSaved);
}
