import 'package:freezed_annotation/freezed_annotation.dart';

import 'asset_type.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

@freezed
abstract class Asset with _$Asset {
  const factory Asset({
    required String id,
    required String uid,
    required String label,
    @Default(AssetType.savings) AssetType type,
    required double value,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
