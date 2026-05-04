import 'package:freezed_annotation/freezed_annotation.dart';

import 'transaction_source.dart';
import 'transaction_type.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String accountId,
    required String categoryId,
    required double amount,
    required TransactionType type,
    required DateTime date,
    required String description,
    @Default('') String notes,
    @Default(TransactionSource.manual) TransactionSource source,
    String? deduplicationHash,
    @Default(false) bool isRecurring,
    String? recurringRuleId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
