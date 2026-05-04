import 'package:freezed_annotation/freezed_annotation.dart';

import 'goal_status.dart';
import 'goal_type.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String uid,
    required String name,
    required double targetAmount,
    required DateTime targetDate,
    required DateTime startDate,
    @Default(0.0) double currentSaved,
    @Default(0.0) double monthlyContribution,
    @Default(1) int priority,
    @Default(GoalStatus.active) GoalStatus status,
    @Default(GoalType.standard) GoalType type,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
