// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_worth_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NetWorthSnapshot _$NetWorthSnapshotFromJson(Map<String, dynamic> json) =>
    _NetWorthSnapshot(
      id: json['id'] as String,
      uid: json['uid'] as String,
      totalAssets: (json['totalAssets'] as num).toDouble(),
      totalLiabilities: (json['totalLiabilities'] as num).toDouble(),
      netWorth: (json['netWorth'] as num).toDouble(),
      capturedAt: DateTime.parse(json['capturedAt'] as String),
    );

Map<String, dynamic> _$NetWorthSnapshotToJson(_NetWorthSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'totalAssets': instance.totalAssets,
      'totalLiabilities': instance.totalLiabilities,
      'netWorth': instance.netWorth,
      'capturedAt': instance.capturedAt.toIso8601String(),
    };
