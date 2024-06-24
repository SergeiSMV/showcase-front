

abstract class BackendRepository{

  Future<List> backendCategories();

  Future<List> backendProducts(int categoryID);

  // Future<Image> backendPicture(String picURL);

  Future<String> authorization(String login, String pass);

  Future<List> backendGetCart();

  Future backendPutCart(Map putData);

  Future<List> putIncrement(int productID);

  Future<List> putDecrement(int productID, int cartQuantity);

  Future<List> putDelete(int productID);

  Future<List> putExact(int productID, int exact);

  Future<List> backendGetRequests();

  Future<void> newRequests(int shipID, String comment);

  Future<List> searchProduct(String keywords);

  Future<List> searchProductByCategory(int categoryID, String keywords);

  Future<List> getRequestsID(int requestID);

  Future<List> backendGetResponses();

  Future<List> getClientAddress();

  Future<List> patchClientAddress(int shipID, bool isDelete, bool isDefault);

  Future<List> addClientAddress(String address);

}