import 'package:flutter/material.dart';
import '../services/auth.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String username, String password) async {
    bool success = await _authService.login(username, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  void logout() {
    _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
