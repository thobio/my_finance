import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_category_repository.dart';
import '../../data/repositories/firestore_transaction_repository.dart';
import '../../data/services/csv_import_service.dart';
import '../../data/services/default_categories.dart';
import '../../domain/models/category.dart';
import '../../domain/models/transaction.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/transaction_repository.dart';

// Repositories

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => FirestoreTransactionRepository(),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => FirestoreCategoryRepository(),
);

// CSV import service

final csvImportServiceProvider = Provider<CsvImportService>(
  (ref) => CsvImportService(
    repository: ref.watch(transactionRepositoryProvider),
  ),
);

// Streams

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final user = ref.watch(authUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(transactionRepositoryProvider).watchAll(user.uid);
});

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final user = ref.watch(authUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchAll(user.uid);
});

// CRUD controller

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, AsyncValue<void>>(
  (ref) => TransactionController(
    repository: ref.watch(transactionRepositoryProvider),
    uid: ref.watch(authUserProvider).valueOrNull?.uid ?? '',
  ),
);

class TransactionController extends StateNotifier<AsyncValue<void>> {
  TransactionController({
    required TransactionRepository repository,
    required String uid,
  })  : _repo = repository,
        _uid = uid,
        super(const AsyncData(null));

  final TransactionRepository _repo;
  final String _uid;

  Future<void> add(Transaction transaction) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.add(_uid, transaction));
  }

  Future<void> update(Transaction transaction) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.update(_uid, transaction));
  }

  Future<void> delete(String transactionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.delete(_uid, transactionId));
  }
}

// Helper: next available transaction ID

String newTransactionId() => const Uuid().v4();

// Category seeder

final categorySeederProvider = Provider<CategorySeeder>((ref) {
  return CategorySeeder(repo: ref.watch(categoryRepositoryProvider));
});

class CategorySeeder {
  CategorySeeder({required CategoryRepository repo}) : _repo = repo;
  final CategoryRepository _repo;

  Future<void> seedForUser(String uid) async {
    for (final cat in DefaultCategories.all) {
      await _repo.add(uid, cat);
    }
  }
}
