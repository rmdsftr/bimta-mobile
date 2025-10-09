import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'dart:convert';

class LogoutService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<LogoutResponse> logout() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/auth/logout');

      final response = await _httpClient.post(
        url,
        body: json.encode({}),
      );

      print('Logout response status: ${response.statusCode}');
      print('Logout response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        await _tokenStorage.clearTokens();

        return LogoutResponse.fromJson(jsonResponse);
      } else {
        await _tokenStorage.clearTokens();

        return LogoutResponse(
          success: true,
          message: 'Logout berhasil (token cleared locally)',
        );
      }
    } catch (e) {
      print('Error during logout: $e');

      await _tokenStorage.clearTokens();

      return LogoutResponse(
        success: true,
        message: 'Logout berhasil (token cleared locally)',
      );
    }
  }
}

class LogoutResponse {
  final bool success;
  final String message;

  LogoutResponse({
    required this.success,
    required this.message,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Logout berhasil',
    );
  }
}