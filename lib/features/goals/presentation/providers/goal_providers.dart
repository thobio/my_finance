import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/firestore_goal_repository.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/goal_contribution.dart';
import '../../domain/repositories/goal_repository.dart';

// ── Streams ───────────────────────────────────────────────────────────────────

final goalsProvider = StreamProvider<List<Goal>>((ref) {
  return ref.watch(goalRepositoryProvider).watchAll();
});

final goalContributionsProvider =
    StreamProvider.family<List<GoalContribution>, String>((ref, goalId) {
  return ref.watch(goalRepositoryProvider).watchContributions(goalId);
});

// ── Controller ────────────────────────────────────────────────────────────────

final goalControllerProvider =
    StateNotifierProvider<GoalController, AsyncValue<void>>(
  (ref) => GoalController(ref.watch(goalRepositoryProvider)),
);

class GoalController extends StateNotifier<AsyncValue<void>> {
  GoalController(this._repo) : super(const AsyncData(null));

  final GoalRepository _repo;
  final _uuid = const Uuid();

  Future<void> add({
    required String uid,
    required String name,
    required double targetAmount,
    required DateTime targetDate,
    required DateTime startDate,
    double currentSaved = 0.0,
    int priority = 1,
    required goalType,
  }) async {
    state = const AsyncLoading();
    final goal = Goal(
      id: _uuid.v4(),
      uid: uid,
      name: name,
      targetAmount: targetAmount,
      targetDate: targetDate,
      startDate: startDate,
      currentSaved: currentSaved,
      priority: priority,
      type: goalType,
    );
    state = await AsyncValue.guard(() => _repo.add(goal));
  }

  Future<void> update(Goal goal) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.update(goal));
  }

  Future<void> delete(String goalId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.delete(goalId));
  }

  Future<void> logContribution({
    required String goalId,
    required double amount,
    required DateTime contributedAt,
    String? sourceTransactionId,
    String note = '',
  }) async {
    state = const AsyncLoading();
    final contrib = GoalContribution(
      id: _uuid.v4(),
      goalId: goalId,
      amount: amount,
      contributedAt: contributedAt,
      sourceTransactionId: sourceTransactionId,
      note: note,
    );
    state = await AsyncValue.guard(() async {
      await _repo.addContribution(contrib);
      final goals = await _repo.watchAll().first;
      final goal = goals.where((g) => g.id == goalId).firstOrNull;
      if (goal != null) {
        await _repo.updateSavedAmount(
          goalId,
          goal.currentSaved + amount,
        );
      }
    });
  }

  Future<void> deleteContribution({
    required String goalId,
    required String contributionId,
    required double amount,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteContribution(goalId, contributionId);
      final goals = await _repo.watchAll().first;
      final goal = goals.where((g) => g.id == goalId).firstOrNull;
      if (goal != null) {
        final newSaved = (goal.currentSaved - amount).clamp(0.0, goal.targetAmount);
        await _repo.updateSavedAmount(goalId, newSaved);
      }
    });
  }
}
