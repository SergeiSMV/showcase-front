
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/backend_implements.dart';

// состояние индексов bottomNavigationBar
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
final lastIndexProvider = StateProvider<int>((ref) => 0);

// провайдеры авторизации
final tokenProvider = StateProvider<String>((ref) => '');

// провайдер бэйджика корзины
final cartBadgesProvider = StateProvider<int>((ref) => 0);

// провайдер категорий
final categoriesProvider = StateProvider<List>((ref) => []);

final baseCategoriesProvider = FutureProvider.autoDispose((ref) async {
  final result = await BackendImplements().backendCategories();
  ref.read(categoriesProvider.notifier).state = result;
});

// провайдер товаров
final productsProvider = StateProvider<List?>((ref) => null);

final baseProductsProvider = FutureProvider.autoDispose.family<List, int>((ref, categoryID) async {
  final List result = await BackendImplements().backendProducts(categoryID, ref);
  ref.read(productsProvider.notifier).state = result;
  return result;
});

// провайдер корзины
final cartProvider = StateProvider<List>((ref) => []);

final baseCartsProvider = FutureProvider.autoDispose((ref) async {
  final result = await BackendImplements().backendGetCart(ref);
  ref.read(cartBadgesProvider.notifier).state = result.length;
  ref.read(cartProvider.notifier).state = result;
  return result;
});

// провайдер заказов
final requestsProvider = StateProvider<List>((ref) => []);

final baseRequestsProvider = FutureProvider.autoDispose((ref) async {
  final result = await BackendImplements().backendGetRequests(ref);
  ref.read(requestsProvider.notifier).state = result;
  return result;
});


// провайдер деталей заказа
final requestDetailProvider = StateProvider<List>((ref) => []);

// провайдер запроса деталей заказа
final getRequestDetailProvider = FutureProvider.autoDispose.family<List, int>((ref, requestID) async {
  final result = await BackendImplements().getRequestsID(requestID, ref);
  ref.read(requestDetailProvider.notifier).state = result;
  return result;
});


// провайдер отгрузок
final responsesProvider = StateProvider<List>((ref) => []);

final baseResponsesProvider = FutureProvider.autoDispose((ref) async {
  final result = await BackendImplements().backendGetResponses(ref);
  ref.read(responsesProvider.notifier).state = result;
  return result;
});


// провайдер адресов клиента
final addressProvider = StateProvider<List>((ref) => []);

// провайдер запроса адресов клиента
final getAddressProvider = FutureProvider.autoDispose((ref) async {
  final result = await BackendImplements().getClientAddress(ref);
  ref.read(addressProvider.notifier).state = result;
  return result;
});

