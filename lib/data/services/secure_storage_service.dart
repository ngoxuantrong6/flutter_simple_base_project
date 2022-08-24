import 'package:sp_util/sp_util.dart';

const String _tokenKey = 'token';

class SecureStorageService {
  static String get token => SpUtil.getString(_tokenKey)!;

  static void saveToken(String token) => SpUtil.putString(_tokenKey, token);

  static void removeToken() => SpUtil.remove(_tokenKey);
}
