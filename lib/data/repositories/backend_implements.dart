
import 'package:showcase_front/data/repositories/hive_implements.dart';

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
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    try {
      Response response = await dio.get('$serverURL$getCategories');
      return response.data ?? [];
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }

  @override
  Future<List> backendProducts(int categoryID) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    try {
      Response response = token.isEmpty ? await dio.get('$serverURL$getProducts/$categoryID') :
      await dio.get('$serverURL$getProducts/$categoryID', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return response.data ?? [];
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
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
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    final Map data = {
      "login": login,
      "password": pass
    };
    try {
      Response response = await dio.post('$serverURL$auth', data: data);
      return response.data.toString();
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return 'failure';
    }
  }
  
  @override
  Future<List> backendGetCart() async {
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get(
        '$serverURL$cart', options: Options(headers: {'Authorization': 'Bearer $token',})
      );
      return response.data ?? [];
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }

  }
  
  @override
  Future backendPutCart(Map putData) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    try {
      await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
    }
  }

  @override
  Future<List> putIncrement(int productID) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    Map putData = {
      "product_id": productID,
      "quantity_incr": 1,
      "quantity_exact": null
    };
    try {
      Response result = await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(result.data);
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }

  @override
  Future<List> putDecrement(int productID, int cartQuantity) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    int? quantityExact = cartQuantity == 1 ? 0 : null;
    int? quantityIncr = cartQuantity == 1 ? null : -1;
    Map putData = {
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      Response result = await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return result.data == null ? [] : List.from(result.data);
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }

  @override
  Future<List> putDelete(int productID) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    Map putData = {
      "product_id": productID,
      "quantity_incr": null,
      "quantity_exact": 0
    };
    try {
      Response result = await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return result.data == null ? [] : List.from(result.data);
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }

  @override
  Future<List> putExact(int productID, int exact) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    int? quantityExact = exact;
    int? quantityIncr;
    Map putData = {
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      Response result = await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(result.data);
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }
  
  @override
  Future<void> newRequests() async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    try {
      await dio.put('$serverURL$putNewRequests', options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      if (e.response != null) {
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
  Future<List> searchProduct(String keywords) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    try {
      Response result = await dio.get('$serverURL$getSearchProduct/$keywords', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(result.data);
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }

  @override
  Future<List> backendGetRequests() async {
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$serverURL$getRequests', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }

  }


  @override
  Future<List> getRequestsID(int requestID) async {
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$serverURL$getRequests/$requestID', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return List.from(response.data);
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }

  }



}