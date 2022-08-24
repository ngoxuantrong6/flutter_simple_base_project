import 'package:flutter_simple_base_project/core/constants/api_path.dart';
import 'package:flutter_simple_base_project/data/api_client.dart';
import 'package:flutter_simple_base_project/data/models/request_method.dart';
import 'package:flutter_simple_base_project/data/models/request_response.dart';
import 'package:flutter_simple_base_project/data/services/secure_storage_service.dart';

class AuthService {
  final ApiClient _client;

  AuthService() : _client = ApiClient();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    RequestResponse res = await _client.fetch(
      ApiPath.login,
      RequestMethod.post,
      data: {
        'email': email,
        'password': password,
      },
    );

    print(res.response);

    if (res.hasError) {
      throw res.error!.messages;
    }

    print(res.data['access_token']);
    SecureStorageService.saveToken(res.data['access_token']);

    return res.result;
  }
}
