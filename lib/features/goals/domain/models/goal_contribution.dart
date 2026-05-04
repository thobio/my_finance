import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_contribution.freezed.dart';
part 'goal_contribution.g.dart';

@freezed
abstract class GoalContribution with _$GoalContribution {
  const factory GoalContribution({
    required String id,
    required String goalId,
    required double amount,
    required DateTime contributedAt,
    String? sourceTransactionId,
    @Default('') String note,
  }) = _GoalContribution;

  factory GoalContribution.fromJson(Map<String, dynamic> json) =>
      _$GoalContributionFromJson(json);
}
