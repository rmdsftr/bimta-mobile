import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/change_judul.dart';
import 'package:bimta/services/auth/token_storage.dart';

class ChangeJudulService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<ChangeJudulResponse> changeJudul(String judulBaru) async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      // Buat request body
      final request = ChangeJudulRequest(judulBaru: judulBaru);

      // Panggil API
      final url = Uri.parse('${ApiConfig.baseUrl}/profil/gantiJudul/$userId');
      final response = await _httpClient.patch(
        url,
        body: jsonEncode(request.toJson()),
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Backend mungkin tidak mengembalikan response body, jadi buat response sukses
        return ChangeJudulResponse(
          success: true,
          message: 'Judul TA berhasil diubah',
        );
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Data tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Mahasiswa tidak ditemukan');
      } else if (response.statusCode == 500) {
        throw Exception('Terjadi kesalahan pada server');
      } else {
        throw Exception('Gagal mengubah judul TA. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Validasi judul TA
  bool validateJudul(String judul) {
    if (judul.trim().isEmpty) {
      return false;
    }
    if (judul.trim().length < 10) {
      return false;
    }
    if (judul.trim().length > 200) {
      return false;
    }
    return true;
  }

  String formatJudul(String judul) {
    final trimmed = judul.trim();
    if (trimmed.isEmpty) return trimmed;

    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }
}