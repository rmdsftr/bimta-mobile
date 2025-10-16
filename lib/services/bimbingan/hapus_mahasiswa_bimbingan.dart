import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'dart:convert';

class HapusBimbinganService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<bool> hapusMahasiswaBimbingan(String mahasiswaId) async {
    try {
      // Ambil dosen_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('Dosen ID tidak ditemukan. Silakan login kembali.');
      }

      // Buat URL endpoint
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/bimbingan/hapus/$dosenId/$mahasiswaId',
      );

      // Kirim request DELETE
      final response = await _httpClient.delete(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Berhasil dihapus
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Data bimbingan tidak ditemukan');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal menghapus mahasiswa dari bimbingan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}