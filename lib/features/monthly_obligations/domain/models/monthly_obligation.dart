import 'package:freezed_annotation/freezed_annotation.dart';

import 'obligation_priority.dart';

part 'monthly_obligation.freezed.dart';
part 'monthly_obligation.g.dart';

@freezed
abstract class MonthlyObligation with _$MonthlyObligation {
  const factory MonthlyObligation({
    required String id,
    required String uid,
    required String label,
    required double amount,
    required int year,
    required int month,
    @Default(1) int dueDay,
    @Default(ObligationPriority.medium) ObligationPriority priority,
    @Default(false) bool isPaid,
    @Default('') String notes,
    String? paidTransactionId,
  }) = _MonthlyObligation;

  factory MonthlyObligation.fromJson(Map<String, dynamic> json) =>
      _$MonthlyObligationFromJson(json);
}
