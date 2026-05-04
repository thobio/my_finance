import 'package:freezed_annotation/freezed_annotation.dart';

part 'distribution_line.freezed.dart';
part 'distribution_line.g.dart';

enum DistributionLineType { fixedObligation, goalContribution, categoryAllocation }

@freezed
abstract class DistributionLine with _$DistributionLine {
  const factory DistributionLine({
    required String label,
    required double amount,
    required DistributionLineType type,
    String? goalId,
    String? categoryId,
  }) = _DistributionLine;

  factory DistributionLine.fromJson(Map<String, dynamic> json) =>
      _$DistributionLineFromJson(json);
}
