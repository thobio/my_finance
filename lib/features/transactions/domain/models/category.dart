import 'package:freezed_annotation/freezed_annotation.dart';

import 'transaction_type.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String icon, // ligature name e.g. 'restaurant'
    required int colorValue, // ARGB int
    required TransactionType type,
    @Default(false) bool isCustom,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
