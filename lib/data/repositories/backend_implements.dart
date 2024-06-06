
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
      baseUrl: apiURL,
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
      Response response = await dio.get(getCategories);
      return response.data ?? [];
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }

  @override
  Future<List> backendProducts(int categoryID) async {
    String token = await HiveImplements().getToken();
    try {
      Response response = token.isEmpty ? await dio.get('$getProducts/$categoryID') :
      await dio.get('$getProducts/$categoryID', options: Options(headers: {'Authorization': 'Bearer $token',}));
      return response.data ?? [];
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }
  }
  
  @override
  Future<Image> backendPicture(String picURL) async {
    try {
      Response response = await dio.get('$apiURL$picURL', options: Options(responseType: ResponseType.bytes));
      return Image.memory(response.data);
    } on DioException catch (_) {
      return Image.asset(categoryImagePath['empty'], scale: 3,);
    }
  }
  
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
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return 'failure';
    }
  }
  
  @override
  Future<List> backendGetCart(int clientID) async {
    final Map data = {
      "client_id": clientID,
    };
    String token = await HiveImplements().getToken();
    try {
      Response response = await dio.get(cart, data: data, options: Options(headers: {'Authorization': 'Bearer $token',}));
      return response.data ?? [];
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
      return [];
    }

  }
  
  @override
  Future backendPutCart(Map putData) async {
    String token = await HiveImplements().getToken();
    try {
      await dio.put(cart, data: putData, options: Options(headers: {'Authorization': 'Bearer $token',}));
    } on DioException catch (e) {
      GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: ${e.message}", 'error');
    }
  }



}