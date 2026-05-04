// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DistributionLine _$DistributionLineFromJson(Map<String, dynamic> json) =>
    _DistributionLine(
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$DistributionLineTypeEnumMap, json['type']),
      goalId: json['goalId'] as String?,
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$DistributionLineToJson(_DistributionLine instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
      'type': _$DistributionLineTypeEnumMap[instance.type]!,
      'goalId': instance.goalId,
      'categoryId': instance.categoryId,
    };

const _$DistributionLineTypeEnumMap = {
  DistributionLineType.fixedObligation: 'fixedObligation',
  DistributionLineType.goalContribution: 'goalContribution',
  DistributionLineType.categoryAllocation: 'categoryAllocation',
};
