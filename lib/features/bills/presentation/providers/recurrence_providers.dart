import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_recurrence_repository.dart';
import '../../domain/models/recurrence.dart';
import '../../domain/models/recurrence_frequency.dart';
import '../../domain/repositories/recurrence_repository.dart';

// ─── Stream ───────────────────────────────────────────────────────────────────

final recurrencesProvider = StreamProvider<List<Recurrence>>((ref) {
  final user = ref.watch(authUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(recurrenceRepositoryProvider).watchAll(user.uid);
});

// ─── Controller ───────────────────────────────────────────────────────────────

class RecurrenceController extends StateNotifier<AsyncValue<void>> {
  RecurrenceController(this._ref) : super(const AsyncData(null));

  final Ref _ref;
  final _uuid = const Uuid();

  RecurrenceRepository get _repo => _ref.read(recurrenceRepositoryProvider);
  String? get _uid => _ref.read(authUserProvider).valueOrNull?.uid;

  Future<void> add({
    required String label,
    required double amount,
    required String categoryId,
    required RecurrenceFrequency frequency,
    required DateTime startDate,
    DateTime? endDate,
    int dayOfMonth = 1,
    bool autoPost = false,
    int reminderOffsetDays = 0,
  }) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncLoading();
    final firstDue = DateTime(startDate.year, startDate.month, dayOfMonth);
    final recurrence = Recurrence(
      id: _uuid.v4(),
      uid: uid,
      label: label,
      amount: amount,
      categoryId: categoryId,
      frequency: frequency,
      dayOfMonth: dayOfMonth,
      startDate: startDate,
      endDate: endDate,
      nextDueDate: firstDue.isBefore(startDate)
          ? frequency.nextAfter(firstDue)
          : firstDue,
      autoPost: autoPost,
      reminderOffsetDays: reminderOffsetDays,
    );
    state = await AsyncValue.guard(() => _repo.add(recurrence));
  }

  Future<void> update(Recurrence recurrence) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.update(recurrence));
  }

  Future<void> delete(String recurrenceId) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => _repo.delete(uid, recurrenceId));
  }

  Future<void> markPaid(String recurrenceId) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.markPaid(uid, recurrenceId, DateTime.now()),
    );
  }
}

final recurrenceControllerProvider =
    StateNotifierProvider<RecurrenceController, AsyncValue<void>>(
  RecurrenceController.new,
);
