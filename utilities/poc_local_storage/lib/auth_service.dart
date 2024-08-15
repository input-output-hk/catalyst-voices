import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;

  factory AuthService() => _instance;
  AuthService._internal();

  bool get isAuthenticated => _isAuthenticated;

  Future<void> deletePassword() async {
    await _storage.delete(key: 'user_password');
    _isAuthenticated = false;
  }

  Future<bool> hasPassword() async {
    final storedPassword = await _storage.read(key: 'user_password');
    return storedPassword != null;
  }

  Future<bool> login(String password) async {
    final storedPassword = await _storage.read(key: 'user_password');
    if (password == storedPassword) {
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
  }

  Future<void> setPassword(String password) async {
    await _storage.write(key: 'user_password', value: password);
  }
}
