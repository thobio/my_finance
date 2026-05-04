// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: json['id'] as String,
  uid: json['uid'] as String,
  name: json['name'] as String,
  type:
      $enumDecodeNullable(_$AccountTypeEnumMap, json['type']) ??
      AccountType.savings,
  lastFourDigits: json['lastFourDigits'] as String?,
  institution: json['institution'] as String?,
  openingBalance: (json['openingBalance'] as num?)?.toDouble() ?? 0.0,
  creditLimit: (json['creditLimit'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'name': instance.name,
  'type': _$AccountTypeEnumMap[instance.type]!,
  'lastFourDigits': instance.lastFourDigits,
  'institution': instance.institution,
  'openingBalance': instance.openingBalance,
  'creditLimit': instance.creditLimit,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$AccountTypeEnumMap = {
  AccountType.savings: 'savings',
  AccountType.current: 'current',
  AccountType.creditCard: 'creditCard',
  AccountType.cash: 'cash',
  AccountType.loan: 'loan',
};
