import 'package:flutter/material.dart';
import 'package:frontend/core/services/auth_service.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/models/models.dart';

class AuthViewModel extends ChangeNotifier {
  final _service = AuthService.instance;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAdmin = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _isAdmin;
  bool get isLoggedIn => _user != null;

  void _setLoading(bool val) { _isLoading = val; notifyListeners(); }
  void _setError(String? val) { _error = val; notifyListeners(); }

  Future<bool> login(String email, String password) async {
    _setLoading(true); _setError(null);
    try {
      _user = await _service.login(email, password);
      _isAdmin = _user!.role == 'admin';
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true); _setError(null);
    try {
      _user = await _service.register(name, email, password);
      _isAdmin = _user!.role == 'admin';
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  Future<void> loadUser() async {
    try {
      _user = await _service.getMe();
      _isAdmin = _user!.role == 'admin';
      notifyListeners();
    } catch (_) {}
  }

  Future<void> logout() async {
    await _service.logout();
    _user = null;
    _isAdmin = false;
    notifyListeners();
  }

  Future<bool> checkLogin() async {
    return await TokenService.instance.isLoggedIn();
  }
}