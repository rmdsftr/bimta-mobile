import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/models/change_password.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<ChangePasswordResponse> changePassword(ChangePasswordDto dto) async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        return ChangePasswordResponse.error('User ID tidak ditemukan');
      }

      // Ambil access token
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        return ChangePasswordResponse.error('Token tidak ditemukan');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/profil/change/$userId');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dto.toJson()),
      ).timeout(
        ApiConfig.connectionTimeout,
        onTimeout: () {
          throw Exception('Koneksi timeout');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ChangePasswordResponse.fromJson(data);
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return ChangePasswordResponse.error(
          data['message'] ?? 'Permintaan tidak valid',
        );
      } else if (response.statusCode == 401) {
        return ChangePasswordResponse.error('Sesi telah berakhir, silakan login kembali');
      } else {
        return ChangePasswordResponse.error(
          'Gagal mengubah password. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ChangePasswordResponse.error(
        'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }
}