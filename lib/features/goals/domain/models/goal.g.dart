// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
  id: json['id'] as String,
  uid: json['uid'] as String,
  name: json['name'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  targetDate: DateTime.parse(json['targetDate'] as String),
  startDate: DateTime.parse(json['startDate'] as String),
  currentSaved: (json['currentSaved'] as num?)?.toDouble() ?? 0.0,
  monthlyContribution: (json['monthlyContribution'] as num?)?.toDouble() ?? 0.0,
  priority: (json['priority'] as num?)?.toInt() ?? 1,
  status:
      $enumDecodeNullable(_$GoalStatusEnumMap, json['status']) ??
      GoalStatus.active,
  type:
      $enumDecodeNullable(_$GoalTypeEnumMap, json['type']) ?? GoalType.standard,
);

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'name': instance.name,
  'targetAmount': instance.targetAmount,
  'targetDate': instance.targetDate.toIso8601String(),
  'startDate': instance.startDate.toIso8601String(),
  'currentSaved': instance.currentSaved,
  'monthlyContribution': instance.monthlyContribution,
  'priority': instance.priority,
  'status': _$GoalStatusEnumMap[instance.status]!,
  'type': _$GoalTypeEnumMap[instance.type]!,
};

const _$GoalStatusEnumMap = {
  GoalStatus.active: 'active',
  GoalStatus.paused: 'paused',
  GoalStatus.achieved: 'achieved',
  GoalStatus.abandoned: 'abandoned',
};

const _$GoalTypeEnumMap = {
  GoalType.standard: 'standard',
  GoalType.emergencyFund: 'emergencyFund',
};
