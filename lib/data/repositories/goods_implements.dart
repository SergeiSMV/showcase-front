

import '../../domain/repositories/goods_repository.dart';

class GoodsImplements extends GoodsRepository{
  
  // получаем дерево категорий
  @override
  Future<List> getCategories() async {
    return [];
  }

  // получаем список продуктов в категории
  @override
  Future<List> getProducts(String categoryID) async {
    return [];
  }

}