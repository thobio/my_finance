// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishItem _$WishItemFromJson(Map<String, dynamic> json) => _WishItem(
  id: json['id'] as String,
  uid: json['uid'] as String,
  name: json['name'] as String,
  estimatedCost: (json['estimatedCost'] as num).toDouble(),
  desiredMonth: DateTime.parse(json['desiredMonth'] as String),
  linkedGoalId: json['linkedGoalId'] as String?,
  status:
      $enumDecodeNullable(_$WishItemStatusEnumMap, json['status']) ??
      WishItemStatus.pending,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$WishItemToJson(_WishItem instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'name': instance.name,
  'estimatedCost': instance.estimatedCost,
  'desiredMonth': instance.desiredMonth.toIso8601String(),
  'linkedGoalId': instance.linkedGoalId,
  'status': _$WishItemStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$WishItemStatusEnumMap = {
  WishItemStatus.pending: 'pending',
  WishItemStatus.achieved: 'achieved',
  WishItemStatus.dropped: 'dropped',
};
