
import 'package:flutter/material.dart';

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
    try {
      Response response = await dio.get('$getProducts/$categoryID');
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



}