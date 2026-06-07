import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/services/token_service.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  final String _base = AppConstants.baseUrl;

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await TokenService.instance.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String path, {bool auth = false, Map<String, String>? query}) async {
    final uri = Uri.parse('$_base$path').replace(queryParameters: query);
    return http.get(uri, headers: await _headers(auth: auth));
  }

  Future<http.Response> post(String path, Map<String, dynamic> body, {bool auth = false}) async {
    final uri = Uri.parse('$_base$path');
    return http.post(uri, headers: await _headers(auth: auth), body: jsonEncode(body));
  }

  Future<http.Response> delete(String path, {bool auth = false}) async {
    final uri = Uri.parse('$_base$path');
    return http.delete(uri, headers: await _headers(auth: auth));
  }

  dynamic parseResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded['data'];
    }
    throw Exception(decoded['message'] ?? 'Something went wrong');
  }
}