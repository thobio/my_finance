// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_contribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalContribution _$GoalContributionFromJson(Map<String, dynamic> json) =>
    _GoalContribution(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      amount: (json['amount'] as num).toDouble(),
      contributedAt: DateTime.parse(json['contributedAt'] as String),
      sourceTransactionId: json['sourceTransactionId'] as String?,
      note: json['note'] as String? ?? '',
    );

Map<String, dynamic> _$GoalContributionToJson(_GoalContribution instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goalId': instance.goalId,
      'amount': instance.amount,
      'contributedAt': instance.contributedAt.toIso8601String(),
      'sourceTransactionId': instance.sourceTransactionId,
      'note': instance.note,
    };
