
import 'package:flutter/material.dart';
import 'package:showcase_front/data/repositories/hive_implements.dart';

import '../../constants/server_config.dart';
import '../../domain/repositories/backend_repository.dart';
import 'package:dio/dio.dart';

import '../../ui/widgets/scaffold_messenger.dart';
import '../models/category_model/category_data.dart';



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
    print('getServerURL: $getServerURL');
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
  
  @override
  Future<Image> backendPicture(String picURL) async {
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    try {
      Response response = await dio.get('$serverURL$picURL', options: Options(responseType: ResponseType.bytes));
      return Image.memory(response.data);
    } on DioException catch (_) {
      return Image.asset(categoryImagePath['empty'], scale: 3,);
    }
  }
  
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
  Future<List> backendGetCart(int clientID) async {
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    final Map data = {
      "client_id": clientID,
    };
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get('$serverURL$cart', data: data, options: Options(headers: {'Authorization': 'Bearer $token',}));
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
  Future<void> putIncrement(int clientID, int productID) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    Map putData = {
      "client_id": clientID,
      "product_id": productID,
      "quantity_incr": 1,
      "quantity_exact": null
    };
    try {
      await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
    }
  }

  @override
  Future<void> putDecrement(int clientID, int productID, int cartQuantity) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    int? quantityExact;
    var quantityIncr = cartQuantity == 1 ? quantityExact = 0 : -1;
    Map putData = {
      "client_id": clientID,
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
    }
  }

  @override
  Future<void> putDelete(int clientID, int productID) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    int? quantityIncr;
    Map putData = {
      "client_id": clientID,
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": 0
    };
    try {
      await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
    }
  }

  @override
  Future<void> putExact(int clientID, int productID, int exact) async {
    String token = await HiveImplements().getToken();
    String getServerURL = await HiveImplements().getServerURL();
    String serverURL = getServerURL.isEmpty ? apiURL : getServerURL;
    int? quantityExact = exact;
    int? quantityIncr;
    Map putData = {
      "client_id": clientID,
      "product_id": productID,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    try {
      await dio.put('$serverURL$cart', data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
    }
  }



}