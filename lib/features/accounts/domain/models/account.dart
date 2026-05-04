import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

enum AccountType { savings, current, creditCard, cash, loan }

extension AccountTypeX on AccountType {
  String get label => switch (this) {
        AccountType.savings => 'Savings',
        AccountType.current => 'Current',
        AccountType.creditCard => 'Credit Card',
        AccountType.cash => 'Cash',
        AccountType.loan => 'Loan',
      };
}

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String uid,
    required String name,
    @Default(AccountType.savings) AccountType type,
    String? lastFourDigits,
    String? institution,
    @Default(0.0) double openingBalance,
    double? creditLimit,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
