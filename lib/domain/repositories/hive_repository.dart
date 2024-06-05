

abstract class HiveRepository{

  Future<void> saveToken(Map authData);

  Future<String> getToken();

}