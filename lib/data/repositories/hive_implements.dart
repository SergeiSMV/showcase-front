import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/repositories/hive_repository.dart';



class HiveImplements extends HiveRepository{

  final Box hive = Hive.box('mainStorage');

  @override
  Future<void> saveToken(Map authData) async {
    await hive.put('token', authData);
  }

  @override
  Future<String> getToken() async {
    String token = await hive.get('authData', defaultValue: '');
    return token;
  }
  
}