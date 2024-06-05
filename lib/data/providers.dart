

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/backend_implements.dart';

// состояние индекса bottomNavigationBar
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

final isAutgorizedProvider = StateProvider<bool>((ref) => false);
final clientIDProvider = StateProvider<int>((ref) => 0);


final categoriesProvider = StateProvider<List>((ref) => []);

final baseCategoriesProvider = FutureProvider((ref) async {
  final result = await BackendImplements().backendCategories();
  ref.read(categoriesProvider.notifier).state = result;
});


final productsProvider = StateProvider<List>((ref) => []);

final baseProductsProvider = FutureProvider.autoDispose.family<List, int>((ref, categoryID) async {
  final result = await BackendImplements().backendProducts(categoryID);
  ref.read(productsProvider.notifier).state = result;
  return result;
});