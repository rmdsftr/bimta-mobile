import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/infoMahasiswa.dart';
import 'package:bimta/services/auth/token_storage.dart';

class MahasiswaInfoService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<MahasiswaInfoResponse> getMahasiswaInfo(String mahasiswaId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/profil/mahasiswa/$mahasiswaId');

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final mahasiswaInfo = MahasiswaInfo.fromJson(jsonData);
        return MahasiswaInfoResponse.success(mahasiswaInfo);
      } else if (response.statusCode == 401) {
        return MahasiswaInfoResponse.error('Unauthorized: Token tidak valid');
      } else if (response.statusCode == 404) {
        return MahasiswaInfoResponse.error('Data mahasiswa tidak ditemukan');
      } else {
        try {
          final errorData = json.decode(response.body);
          return MahasiswaInfoResponse.error(
            errorData['message'] ?? 'Gagal mengambil informasi mahasiswa',
          );
        } catch (e) {
          return MahasiswaInfoResponse.error('Gagal mengambil informasi mahasiswa');
        }
      }
    } catch (e) {
      return MahasiswaInfoResponse.error(
        'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  // Method untuk mendapatkan info dari user yang sedang login
  Future<MahasiswaInfoResponse> getMyInfo() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        return MahasiswaInfoResponse.error('User ID tidak ditemukan');
      }

      return await getMahasiswaInfo(userId);
    } catch (e) {
      return MahasiswaInfoResponse.error(
        'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }
}