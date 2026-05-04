// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetMonth _$BudgetMonthFromJson(Map<String, dynamic> json) => _BudgetMonth(
  yearMonth: json['yearMonth'] as String,
  projected:
      (json['projected'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  actual:
      (json['actual'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  incomeProjected: (json['incomeProjected'] as num?)?.toDouble() ?? 0.0,
  incomeActual: (json['incomeActual'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$BudgetMonthToJson(_BudgetMonth instance) =>
    <String, dynamic>{
      'yearMonth': instance.yearMonth,
      'projected': instance.projected,
      'actual': instance.actual,
      'incomeProjected': instance.incomeProjected,
      'incomeActual': instance.incomeActual,
    };
