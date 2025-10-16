import 'package:bimta/services/auth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticatedHttpClient {
  static final AuthenticatedHttpClient _instance = AuthenticatedHttpClient._internal();
  factory AuthenticatedHttpClient() => _instance;
  AuthenticatedHttpClient._internal();

  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _tokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(Uri url) async {
    final headers = await _getHeaders();
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post(Uri url, {Object? body}) async {
    final headers = await _getHeaders();
    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> put(Uri url, {Object? body}) async {
    final headers = await _getHeaders();
    return await http.put(url, headers: headers, body: body);
  }

  Future<http.Response> patch(Uri url, {Object? body}) async {
    final headers = await _getHeaders();
    return await http.patch(url, headers: headers, body: body);
  }

  Future<http.Response> delete(Uri url) async {
    final headers = await _getHeaders();
    return await http.delete(url, headers: headers);
  }
}