// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Asset _$AssetFromJson(Map<String, dynamic> json) => _Asset(
  id: json['id'] as String,
  uid: json['uid'] as String,
  label: json['label'] as String,
  type:
      $enumDecodeNullable(_$AssetTypeEnumMap, json['type']) ??
      AssetType.savings,
  value: (json['value'] as num).toDouble(),
);

Map<String, dynamic> _$AssetToJson(_Asset instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'label': instance.label,
  'type': _$AssetTypeEnumMap[instance.type]!,
  'value': instance.value,
};

const _$AssetTypeEnumMap = {
  AssetType.savings: 'savings',
  AssetType.investment: 'investment',
  AssetType.property: 'property',
  AssetType.vehicle: 'vehicle',
  AssetType.other: 'other',
};
