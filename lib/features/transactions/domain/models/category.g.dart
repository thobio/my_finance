// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String,
  colorValue: (json['colorValue'] as num).toInt(),
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  isCustom: json['isCustom'] as bool? ?? false,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'colorValue': instance.colorValue,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'isCustom': instance.isCustom,
};

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
