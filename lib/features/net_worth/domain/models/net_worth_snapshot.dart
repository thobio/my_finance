import 'package:freezed_annotation/freezed_annotation.dart';

part 'net_worth_snapshot.freezed.dart';
part 'net_worth_snapshot.g.dart';

@freezed
abstract class NetWorthSnapshot with _$NetWorthSnapshot {
  const factory NetWorthSnapshot({
    required String id, // YYYY-MM
    required String uid,
    required double totalAssets,
    required double totalLiabilities,
    required double netWorth,
    required DateTime capturedAt,
  }) = _NetWorthSnapshot;

  factory NetWorthSnapshot.fromJson(Map<String, dynamic> json) =>
      _$NetWorthSnapshotFromJson(json);
}
