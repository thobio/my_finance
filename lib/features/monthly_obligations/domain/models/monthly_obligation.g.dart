// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_obligation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyObligation _$MonthlyObligationFromJson(Map<String, dynamic> json) =>
    _MonthlyObligation(
      id: json['id'] as String,
      uid: json['uid'] as String,
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      dueDay: (json['dueDay'] as num?)?.toInt() ?? 1,
      priority:
          $enumDecodeNullable(_$ObligationPriorityEnumMap, json['priority']) ??
          ObligationPriority.medium,
      isPaid: json['isPaid'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      paidTransactionId: json['paidTransactionId'] as String?,
    );

Map<String, dynamic> _$MonthlyObligationToJson(_MonthlyObligation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'label': instance.label,
      'amount': instance.amount,
      'year': instance.year,
      'month': instance.month,
      'dueDay': instance.dueDay,
      'priority': _$ObligationPriorityEnumMap[instance.priority]!,
      'isPaid': instance.isPaid,
      'notes': instance.notes,
      'paidTransactionId': instance.paidTransactionId,
    };

const _$ObligationPriorityEnumMap = {
  ObligationPriority.high: 'high',
  ObligationPriority.medium: 'medium',
  ObligationPriority.low: 'low',
};
