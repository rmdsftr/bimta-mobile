import 'dart:convert';
import 'dart:io';
import 'package:bimta/config/api.dart';
import 'package:bimta/models/login.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final TokenStorage _tokenStorage = TokenStorage();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http
          .post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode(request.toJson()),
      )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);

        if (loginResponse.data != null) {
          await _tokenStorage.saveTokens(
            accessToken: loginResponse.data!.access_token,
            refreshToken: loginResponse.data!.refresh_token,
            userId: loginResponse.data!.userId,
            nama: loginResponse.data!.nama,
            role: loginResponse.data!.role,
          );
        }

        return loginResponse;
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: errorData['message'] ?? 'NIM/NIP atau password salah',
        );
      } else if (response.statusCode >= 500) {
        return LoginResponse(
          success: false,
          message: 'Server sedang bermasalah. Silakan coba lagi nanti.',
        );
      } else {
        final errorData = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: errorData['message'] ?? 'Login gagal',
        );
      }
    } on SocketException {
      return LoginResponse(
        success: false,
        message: 'Tidak ada koneksi internet. Periksa koneksi Anda.',
      );
    } on http.ClientException {
      return LoginResponse(
        success: false,
        message: 'Gagal terhubung ke server. Periksa koneksi Anda.',
      );
    } on FormatException {
      return LoginResponse(
        success: false,
        message: 'Response server tidak valid.',
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  Future<bool> isLoggedIn() async {
    return await _tokenStorage.isLoggedIn();
  }

  Future<Map<String, String?>> getCurrentUser() async {
    return await _tokenStorage.getUserData();
  }
}