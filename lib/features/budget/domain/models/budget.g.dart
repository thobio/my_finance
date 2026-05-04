// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
  id: json['id'] as String,
  uid: json['uid'] as String,
  year: (json['year'] as num).toInt(),
  totalProjectedIncome:
      (json['totalProjectedIncome'] as num?)?.toDouble() ?? 0.0,
  fixedObligations:
      (json['fixedObligations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  monthlyAllocations:
      (json['monthlyAllocations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'year': instance.year,
  'totalProjectedIncome': instance.totalProjectedIncome,
  'fixedObligations': instance.fixedObligations,
  'monthlyAllocations': instance.monthlyAllocations,
};
