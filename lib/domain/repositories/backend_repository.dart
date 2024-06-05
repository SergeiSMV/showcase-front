



import 'package:flutter/material.dart';

abstract class BackendRepository{

  Future<List> backendCategories();

  Future<List> backendProducts(int categoryID);

  Future<Image> backendPicture(String picURL);

}