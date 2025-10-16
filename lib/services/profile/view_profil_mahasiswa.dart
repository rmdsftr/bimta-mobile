import 'dart:convert';

import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/view_profil_mahasiswa.dart';

class ProfileMahasiswaService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();

  Future<ProfileMahasiswa> getProfileMahasiswa(String mahasiswaId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/profil/view/$mahasiswaId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Cek apakah response berupa List atau Object
        if (responseData is List) {
          // Jika List, ambil elemen pertama
          if (responseData.isEmpty) {
            throw Exception('Data mahasiswa tidak ditemukan');
          }
          return ProfileMahasiswa.fromJson(responseData[0]);
        } else if (responseData is Map<String, dynamic>) {
          // Jika Object langsung
          return ProfileMahasiswa.fromJson(responseData);
        } else {
          throw Exception('Format response tidak valid');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Mahasiswa tidak ditemukan');
      } else {
        throw Exception('Gagal memuat profil mahasiswa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat profil mahasiswa: $e');
    }
  }
}