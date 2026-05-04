import '../models/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchAll(String uid);
  Future<Category> add(String uid, Category category);
  Future<void> update(String uid, Category category);
  Future<void> delete(String uid, String categoryId);
}
