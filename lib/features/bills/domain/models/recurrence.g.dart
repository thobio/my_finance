// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recurrence _$RecurrenceFromJson(Map<String, dynamic> json) => _Recurrence(
  id: json['id'] as String,
  uid: json['uid'] as String,
  label: json['label'] as String,
  amount: (json['amount'] as num).toDouble(),
  categoryId: json['categoryId'] as String,
  frequency: $enumDecode(_$RecurrenceFrequencyEnumMap, json['frequency']),
  dayOfMonth: (json['dayOfMonth'] as num?)?.toInt() ?? 1,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  nextDueDate: DateTime.parse(json['nextDueDate'] as String),
  lastPaidDate: json['lastPaidDate'] == null
      ? null
      : DateTime.parse(json['lastPaidDate'] as String),
  isActive: json['isActive'] as bool? ?? true,
  autoPost: json['autoPost'] as bool? ?? false,
  reminderOffsetDays: (json['reminderOffsetDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RecurrenceToJson(_Recurrence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'label': instance.label,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'frequency': _$RecurrenceFrequencyEnumMap[instance.frequency]!,
      'dayOfMonth': instance.dayOfMonth,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'nextDueDate': instance.nextDueDate.toIso8601String(),
      'lastPaidDate': instance.lastPaidDate?.toIso8601String(),
      'isActive': instance.isActive,
      'autoPost': instance.autoPost,
      'reminderOffsetDays': instance.reminderOffsetDays,
    };

const _$RecurrenceFrequencyEnumMap = {
  RecurrenceFrequency.daily: 'daily',
  RecurrenceFrequency.weekly: 'weekly',
  RecurrenceFrequency.biweekly: 'biweekly',
  RecurrenceFrequency.monthly: 'monthly',
  RecurrenceFrequency.everyTwoMonths: 'everyTwoMonths',
  RecurrenceFrequency.quarterly: 'quarterly',
  RecurrenceFrequency.yearly: 'yearly',
};
