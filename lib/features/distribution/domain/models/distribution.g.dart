// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Distribution _$DistributionFromJson(Map<String, dynamic> json) =>
    _Distribution(
      id: json['id'] as String,
      uid: json['uid'] as String,
      sourceTransactionId: json['sourceTransactionId'] as String,
      income: (json['income'] as num).toDouble(),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => DistributionLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      accepted: json['accepted'] as bool? ?? false,
    );

Map<String, dynamic> _$DistributionToJson(_Distribution instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'sourceTransactionId': instance.sourceTransactionId,
      'income': instance.income,
      'lines': instance.lines,
      'accepted': instance.accepted,
    };
