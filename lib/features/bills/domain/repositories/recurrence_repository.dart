import '../models/recurrence.dart';

abstract class RecurrenceRepository {
  Stream<List<Recurrence>> watchAll(String uid);
  Future<void> add(Recurrence recurrence);
  Future<void> update(Recurrence recurrence);
  Future<void> delete(String uid, String recurrenceId);
  Future<void> markPaid(String uid, String recurrenceId, DateTime paidDate);
}
