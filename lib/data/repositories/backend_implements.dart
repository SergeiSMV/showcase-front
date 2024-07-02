
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcase_front/data/repositories/hive_implements.dart';
import 'package:showcase_front/data/repositories/usecase_implements.dart';

import '../../constants/server_config.dart';
import '../../domain/repositories/backend_repository.dart';
import 'package:dio/dio.dart';

import '../../ui/widgets/scaffold_messenger.dart';



class BackendImplements extends BackendRepository{
 
  final dio = Dio(
    BaseOptions(
      // baseUrl: apiURL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    )
  );  


  @override
  Future<List> backendCategories() async {
    try {
      Response response = await dio.get('$apiURL$getBackCategories');
      return response.data ?? [];
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }

  @override
  Future<List> backendProducts(int categoryID, AutoDisposeFutureProviderRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response response = token.isEmpty ? await dio.get('$apiURL$getBackProducts/$categoryID') :
      await dio.get('$apiURL$getBackProducts/$categoryID', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return response.data ?? [];
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginProviderRef(ref);
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return [];
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return [];
      }
    }
  }
  
  // @override
  // Future<Image> backendPicture(String picURL) async {
  //   String getServerURL = await HiveImplements().getServerURL();
  //   String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
  //   try {
  //     Response response = await dio.get('$serverURL$picURL', options: Options(responseType: ResponseType.bytes));
  //     return Image.memory(response.data);
  //   } on DioException catch (_) {
  //     return Image.asset(categoryImagePath['empty'], scale: 3,);
  //   }
  // }
  
  @override
  Future<String> authorization(String login, String pass) async {
    final Map data = {
      "login": login,
      "password": pass
    };
    try {
      Response response = await dio.post('$apiURL$auth', data: data);
      return response.data.toString();
    } on DioException catch (e) {

      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Не верный логин или пароль!", 'error');
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return '';
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return '';
      }
    }
  }
  
  @override
  Future<List> backendGetCart(AutoDisposeFutureProviderRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get(
        '$apiURL$cart', options: Options(headers: {'Authorization': 'Bearer $token',})
      );
      return response.data ?? [];
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginProviderRef(ref);
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return [];
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return [];
      }
    }

  }
  
  // @override
  // Future backendPutCart(Map putData) async {
  //   String token = await HiveImplements().getToken();
  //   try {
  //     await dio.put('$apiURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
  //   } on DioException catch (e) {
  //     GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
  //   }
  // }

  @override
  Future<List> putIncrement(int productID, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    Map putData = {
      "product_id": productID,
      "quantity_incr": 1,
      "quantity_exact": null
    };
    try {
      Response result = await dio.put('$apiURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return [];
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return [];
      }
    }
  }

  @override
  Future<List> putDecrement(int productID, int cartQuantity, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    int? quantityExact = cartQuantity == 1 ? 0 : null;
    int? quantityIncr = cartQuantity == 1 ? null : -1;
    Map putData = {
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      Response result = await dio.put('$apiURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return result.data == null ? [] : List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return [];
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return [];
      }
    }
  }

  @override
  Future<List> putDelete(int productID, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    Map putData = {
      "product_id": productID,
      "quantity_incr": null,
      "quantity_exact": 0
    };
    try {
      Response result = await dio.put('$apiURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return result.data == null ? [] : List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return [];
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return [];
      }
    }
  }

  @override
  Future<List> putExact(int productID, int exact, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    int? quantityExact = exact;
    int? quantityIncr;
    Map putData = {
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      Response result = await dio.put('$apiURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        }
        if (e.response!.statusCode == 422){
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка валидации!", 'error');
        }
        return [];
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        return [];
      }
    }
  }
  
  @override
  Future<void> newRequests(int shipID, String comment, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    Map putData = {
      "ship_to_id": shipID,
      "comment": comment,
    };
    try {
      await dio.put('$apiURL$putBackNewRequests', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        }
        if (e.response!.statusCode == 404) {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: Заявка не может быть обработана! Недостаточно товара на складе!", 'error');
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
        }
      } else {
        GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      }
    }

  }


  @override
  Future<List> searchProduct(String keywords, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response result = await dio.get('$apiURL$getBackSearchProduct/$keywords', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        }
      }
      return [];
    }
  }

  @override
  Future<List> searchProductByCategory(int categoryID, String keywords, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response result = await dio.get('$apiURL$getBackSearchByCategory/$categoryID/$keywords', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(result.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }

  @override
  Future<List> backendGetRequests(AutoDisposeFutureProviderRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$apiURL$getBackRequests', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginProviderRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }


  @override
  Future<List> getRequestsID(int requestID, AutoDisposeFutureProviderRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$apiURL$getBackRequests/$requestID', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginProviderRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }


  @override
  Future<List> backendGetResponses(AutoDisposeFutureProviderRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$apiURL$getBackResponses', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginProviderRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }


  @override
  Future<List> getClientAddress(AutoDisposeFutureProviderRef ref) async {
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$apiURL$backClientAddress', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginProviderRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }

  @override
  Future<List> patchClientAddress(int shipID, bool isDelete, bool isDefault, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    Map putData = {
      "ship_to_id": shipID,
      "delete": isDelete,
      "default": isDefault
    };
    try {
      Response response = await dio.patch('$apiURL$backClientAddress', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }

  @override
  Future<List> addClientAddress(String address, WidgetRef ref) async {
    String token = await HiveImplements().getToken();
    Map putData = {
      "address": address
    };
    try {
      Response response = await dio.put('$apiURL$backClientAddress', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 403 || e.response!.statusCode == 401){
          GlobalScaffoldMessenger.instance.showSnackBar("Необходимо повторно авторизоваться!", 'error');
          UseCaseImplements().unloginWidgetRef(ref);
        } else {
          GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: $e", 'error');
        }
      }
      return [];
    }
  }


}