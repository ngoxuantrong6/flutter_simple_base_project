import 'package:flutter/foundation.dart';
import 'package:flutter_simple_base_project/core/data_types.dart';
import 'package:flutter_simple_base_project/core/error_handling/app_error_state.dart';
import '../service/auth_service.dart';

enum LoginViewState { idle, loading, loginFalied }

class LoginModel extends ChangeNotifier {
  LoginModel()
      : _email = StringVs(),
        _password = StringVs(),
        _authService = AuthService(),
        _state = LoginViewState.idle;

  final StringVs _email;
  final StringVs _password;

  StringVs get email => _email;
  StringVs get password => _password;

  final AuthService _authService;

  LoginViewState _state;

  LoginViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setState(LoginViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future<bool> login() async {
    try {
      _setState(LoginViewState.loading);

      final result = await _authService.login(
        email: _email.value,
        password: _password.value,
      );

      _setState(LoginViewState.idle);

      return result;
    } catch (e) {
      print(e);

      _errorMessage = AppErrorStateExt.getFriendlyErrorString(e);

      _setState(LoginViewState.loginFalied);

      return false;
    }
  }
}
