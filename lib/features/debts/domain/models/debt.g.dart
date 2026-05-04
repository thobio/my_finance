// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Debt _$DebtFromJson(Map<String, dynamic> json) => _Debt(
  id: json['id'] as String,
  uid: json['uid'] as String,
  label: json['label'] as String,
  type: $enumDecodeNullable(_$DebtTypeEnumMap, json['type']) ?? DebtType.loan,
  outstanding: (json['outstanding'] as num).toDouble(),
  interestRatePercent: (json['interestRatePercent'] as num).toDouble(),
  minimumPayment: (json['minimumPayment'] as num).toDouble(),
  dueDay: (json['dueDay'] as num?)?.toInt() ?? 1,
  linkedAccountId: json['linkedAccountId'] as String?,
  creditLimit: (json['creditLimit'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DebtToJson(_Debt instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'label': instance.label,
  'type': _$DebtTypeEnumMap[instance.type]!,
  'outstanding': instance.outstanding,
  'interestRatePercent': instance.interestRatePercent,
  'minimumPayment': instance.minimumPayment,
  'dueDay': instance.dueDay,
  'linkedAccountId': instance.linkedAccountId,
  'creditLimit': instance.creditLimit,
};

const _$DebtTypeEnumMap = {
  DebtType.loan: 'loan',
  DebtType.creditCard: 'creditCard',
  DebtType.bnpl: 'bnpl',
};
