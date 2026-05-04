import 'package:freezed_annotation/freezed_annotation.dart';

import 'recurrence_frequency.dart';

part 'recurrence.freezed.dart';
part 'recurrence.g.dart';

@freezed
abstract class Recurrence with _$Recurrence {
  const factory Recurrence({
    required String id,
    required String uid,
    required String label,
    required double amount,
    required String categoryId,
    required RecurrenceFrequency frequency,
    /// Day of month for monthly/quarterly/yearly (1–31).
    @Default(1) int dayOfMonth,
    required DateTime startDate,
    DateTime? endDate,
    required DateTime nextDueDate,
    DateTime? lastPaidDate,
    @Default(true) bool isActive,
    @Default(false) bool autoPost,
    @Default(0) int reminderOffsetDays,
  }) = _Recurrence;

  factory Recurrence.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceFromJson(json);
}
