



import 'package:flutter/material.dart';

abstract class BackendRepository{

  Future<List> backendCategories();

  Future<List> backendProducts(int categoryID);

  // Future<Image> backendPicture(String picURL);

  Future<String> authorization(String login, String pass);

  Future<List> backendGetCart(int clientID);

  Future backendPutCart(Map putData);

  Future<List> putIncrement(int clientID, int productID);

  Future<List> putDecrement(int clientID, int productID, int cartQuantity);

  Future<List> putDelete(int clientID, int productID);

  Future<List> putExact(int clientID, int productID, int exact);

  Future<List> backendGetRequests(int clientID);

  Future<void> newRequests();

  Future<List> searchProduct(String keywords);

}