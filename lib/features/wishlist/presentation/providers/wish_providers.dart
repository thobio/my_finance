import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_wish_item_repository.dart';
import '../../domain/models/wish_item.dart';
import '../../domain/models/wish_item_status.dart';
import '../../domain/repositories/wish_item_repository.dart';

final wishItemsProvider = StreamProvider<List<WishItem>>((ref) {
  return ref.watch(wishItemRepositoryProvider).watchAll();
});

final wishControllerProvider =
    StateNotifierProvider<WishController, AsyncValue<void>>(
  WishController.new,
);

class WishController extends StateNotifier<AsyncValue<void>> {
  WishController(this._ref) : super(const AsyncData(null));

  final Ref _ref;
  final _uuid = const Uuid();

  WishItemRepository get _repo => _ref.read(wishItemRepositoryProvider);

  Future<void> add({
    required String name,
    required double estimatedCost,
    required DateTime desiredMonth,
    String? linkedGoalId,
  }) async {
    state = const AsyncLoading();
    final uid = _ref.read(authUserProvider).valueOrNull?.uid ?? '';
    final item = WishItem(
      id: _uuid.v4(),
      uid: uid,
      name: name,
      estimatedCost: estimatedCost,
      desiredMonth: DateTime(desiredMonth.year, desiredMonth.month),
      linkedGoalId: linkedGoalId,
      createdAt: DateTime.now(),
    );
    state = await AsyncValue.guard(() => _repo.add(item));
  }

  Future<void> update(WishItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.update(item));
  }

  Future<void> markAchieved(WishItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.update(item.copyWith(status: WishItemStatus.achieved)),
    );
  }

  Future<void> markDropped(WishItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.update(item.copyWith(status: WishItemStatus.dropped)),
    );
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.delete(id));
  }
}
