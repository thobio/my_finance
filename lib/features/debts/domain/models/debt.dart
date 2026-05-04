import 'package:freezed_annotation/freezed_annotation.dart';

import 'debt_type.dart';

part 'debt.freezed.dart';
part 'debt.g.dart';

@freezed
abstract class Debt with _$Debt {
  const factory Debt({
    required String id,
    required String uid,
    required String label,
    @Default(DebtType.loan) DebtType type,
    required double outstanding,
    required double interestRatePercent,
    required double minimumPayment,
    @Default(1) int dueDay,
    String? linkedAccountId,
    double? creditLimit,
  }) = _Debt;

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
}
