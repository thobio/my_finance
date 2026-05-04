import '../models/wish_item.dart';

abstract class WishItemRepository {
  Stream<List<WishItem>> watchAll();
  Future<void> add(WishItem item);
  Future<void> update(WishItem item);
  Future<void> delete(String id);
}
