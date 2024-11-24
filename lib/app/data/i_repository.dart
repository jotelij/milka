import 'models/models.dart';

abstract class IRepository {
  Future<ResponseModel> searchResult(String searchWord);
  Future<TokenModel> refreshToken();
  String? get getAccessToken;

  // Future<TokenModel> saveToken();
}
