import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/add_mahasiswa_bimbingan.dart';
import 'package:bimta/services/auth/token_storage.dart';

class AddMahasiswaBimbinganService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<bool> addMahasiswaBimbingan(List<String> mahasiswaIds) async {
    try {
      if (mahasiswaIds.isEmpty) {
        throw Exception('Daftar mahasiswa tidak boleh kosong');
      }

      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('Dosen ID tidak ditemukan. Silakan login kembali.');
      }

      final dto = AddMahasiswaBimbinganDto(
        dosenId: dosenId,
        mahasiswaId: mahasiswaIds,
      );

      final url = Uri.parse('${ApiConfig.baseUrl}/bimbingan/add');
      final response = await _httpClient.post(
        url,
        body: json.encode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);

        if (responseBody == true || responseBody['success'] == true) {
          return true;
        } else {
          throw Exception('Response tidak valid dari server');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Data tidak valid. Periksa kembali mahasiswa yang dipilih.');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (response.statusCode == 409) {
        throw Exception('Beberapa mahasiswa sudah terdaftar dalam bimbingan Anda.');
      } else {
        throw Exception('Gagal menambahkan mahasiswa: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in addMahasiswaBimbingan: $e');

      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Terjadi kesalahan saat menambahkan mahasiswa: ${e.toString()}');
      }
    }
  }

  Future<List<String>> checkExistingMahasiswa(List<String> mahasiswaIds) async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('Dosen ID tidak ditemukan');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/bimbingan/check-existing');
      final response = await _httpClient.post(
        url,
        body: json.encode({
          'dosen_id': dosenId,
          'mahasiswa_id': mahasiswaIds,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> existing = json.decode(response.body);
        return existing.cast<String>();
      }

      return [];
    } catch (e) {
      print('Error checking existing mahasiswa: $e');
      return [];
    }
  }
}