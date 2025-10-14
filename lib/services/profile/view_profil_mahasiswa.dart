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
        final data = jsonDecode(response.body);
        return ProfileMahasiswa.fromJson(data);
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