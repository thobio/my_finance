import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';

class FirestoreCategoryRepository implements CategoryRepository {
  FirestoreCategoryRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('categories');

  @override
  Stream<List<Category>> watchAll(String uid) {
    return _col(uid).snapshots().map((snap) => snap.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return Category.fromJson(data);
        }).toList());
  }

  @override
  Future<Category> add(String uid, Category category) async {
    await _col(uid).doc(category.id).set(_toFirestore(category));
    return category;
  }

  @override
  Future<void> update(String uid, Category category) {
    return _col(uid).doc(category.id).update(_toFirestore(category));
  }

  @override
  Future<void> delete(String uid, String categoryId) {
    return _col(uid).doc(categoryId).delete();
  }

  Map<String, dynamic> _toFirestore(Category cat) {
    final json = cat.toJson();
    json.remove('id');
    return json;
  }
}

