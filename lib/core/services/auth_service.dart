import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/models/models.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final _client = ApiClient.instance;

  Future<UserModel> login(String email, String password) async {
    final res = await _client.post(ApiEndpoints.login, {'email': email, 'password': password});
    final data = _client.parseResponse(res);
    await TokenService.instance.saveToken(data['token'], data['user']['role']);
    return UserModel.fromJson(data['user']);
  }

  Future<UserModel> register(String name, String email, String password) async {
    final res = await _client.post(ApiEndpoints.register, {'name': name, 'email': email, 'password': password});
    final data = _client.parseResponse(res);
    await TokenService.instance.saveToken(data['token'], data['user']['role']);
    return UserModel.fromJson(data['user']);
  }

  Future<UserModel> getMe() async {
    final res = await _client.get(ApiEndpoints.me, auth: true);
    final data = _client.parseResponse(res);
    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    await TokenService.instance.clearToken();
  }
}