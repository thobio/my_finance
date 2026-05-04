import 'package:freezed_annotation/freezed_annotation.dart';

import 'wish_item_status.dart';

part 'wish_item.freezed.dart';
part 'wish_item.g.dart';

@freezed
abstract class WishItem with _$WishItem {
  const factory WishItem({
    required String id,
    required String uid,
    required String name,
    required double estimatedCost,
    required DateTime desiredMonth,
    String? linkedGoalId,
    @Default(WishItemStatus.pending) WishItemStatus status,
    required DateTime createdAt,
  }) = _WishItem;

  factory WishItem.fromJson(Map<String, dynamic> json) =>
      _$WishItemFromJson(json);
}
