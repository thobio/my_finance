// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: json['id'] as String,
  accountId: json['accountId'] as String,
  categoryId: json['categoryId'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  date: DateTime.parse(json['date'] as String),
  description: json['description'] as String,
  notes: json['notes'] as String? ?? '',
  source:
      $enumDecodeNullable(_$TransactionSourceEnumMap, json['source']) ??
      TransactionSource.manual,
  deduplicationHash: json['deduplicationHash'] as String?,
  isRecurring: json['isRecurring'] as bool? ?? false,
  recurringRuleId: json['recurringRuleId'] as String?,
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'notes': instance.notes,
      'source': _$TransactionSourceEnumMap[instance.source]!,
      'deduplicationHash': instance.deduplicationHash,
      'isRecurring': instance.isRecurring,
      'recurringRuleId': instance.recurringRuleId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};

const _$TransactionSourceEnumMap = {
  TransactionSource.manual: 'manual',
  TransactionSource.csv: 'csv',
};
