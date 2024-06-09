

abstract class HiveRepository{

  Future<void> saveToken(String token);

  Future<String> getToken();

  Future<void> saveServerURL(String url);

  Future<String> getServerURL();

}