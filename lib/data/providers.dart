

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/backend_implements.dart';

final serverURLProvider = StateProvider<String>((ref) => '');

// состояние индекса bottomNavigationBar
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// провайдеры авторизации
final isAutgorizedProvider = StateProvider<bool>((ref) => false);
final clientIDProvider = StateProvider<int>((ref) => 0);

// провайдер бэйджика корзины
final cartBadgesProvider = StateProvider<int>((ref) => 0);

// провайдер категорий
final categoriesProvider = StateProvider<List>((ref) => []);

final baseCategoriesProvider = FutureProvider.autoDispose((ref) async {
  final result = await BackendImplements().backendCategories();
  ref.read(categoriesProvider.notifier).state = result;
});

// провайдер товаров
final productsProvider = StateProvider<List>((ref) => []);

final baseProductsProvider = FutureProvider.autoDispose.family<List, int>((ref, categoryID) async {
  final result = await BackendImplements().backendProducts(categoryID);
  ref.read(productsProvider.notifier).state = result;
  return result;
});

// провайдер корзины
final cartProvider = StateProvider<List>((ref) => []);

final baseCartsProvider = FutureProvider.autoDispose.family<List, int>((ref, clientID) async {
  final result = await BackendImplements().backendGetCart(clientID);
  ref.read(cartBadgesProvider.notifier).state = result.length;
  ref.read(cartProvider.notifier).state = result;
  return result;
});