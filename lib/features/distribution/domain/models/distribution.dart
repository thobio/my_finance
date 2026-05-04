import 'package:freezed_annotation/freezed_annotation.dart';

import 'distribution_line.dart';

part 'distribution.freezed.dart';
part 'distribution.g.dart';

@freezed
abstract class Distribution with _$Distribution {
  const factory Distribution({
    required String id,
    required String uid,
    required String sourceTransactionId,
    required double income,
    required List<DistributionLine> lines,
    @Default(false) bool accepted,
  }) = _Distribution;

  factory Distribution.fromJson(Map<String, dynamic> json) =>
      _$DistributionFromJson(json);
}
