


abstract class GoodsRepository{

  Future<List> getCategories();

  Future<List> getProducts(String categoryID);

}