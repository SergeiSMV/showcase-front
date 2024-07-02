

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BackendRepository{

  Future<List> backendCategories();

  Future<List> backendProducts(int categoryID, AutoDisposeFutureProviderRef ref);

  // Future<Image> backendPicture(String picURL);

  Future<String> authorization(String login, String pass);

  Future<List> backendGetCart(AutoDisposeFutureProviderRef ref);

  // Future backendPutCart(Map putData);

  Future<List> putIncrement(int productID, WidgetRef ref);

  Future<List> putDecrement(int productID, int cartQuantity, WidgetRef ref);

  Future<List> putDelete(int productID, WidgetRef ref);

  Future<List> putExact(int productID, int exact, WidgetRef ref);

  Future<List> backendGetRequests(AutoDisposeFutureProviderRef ref);

  Future<void> newRequests(int shipID, String comment, WidgetRef ref);

  Future<List> searchProduct(String keywords, WidgetRef ref);

  Future<List> searchProductByCategory(int categoryID, String keywords, WidgetRef ref);

  Future<List> getRequestsID(int requestID, AutoDisposeFutureProviderRef ref);

  Future<List> backendGetResponses(AutoDisposeFutureProviderRef ref);

  Future<List> getClientAddress(AutoDisposeFutureProviderRef ref);

  Future<List> patchClientAddress(int shipID, bool isDelete, bool isDefault, WidgetRef ref);

  Future<List> addClientAddress(String address, WidgetRef ref);

}