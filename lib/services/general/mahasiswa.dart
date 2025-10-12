import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/mahasiswa.dart';
import 'package:bimta/models/referensi.dart';
import 'package:bimta/services/auth/token_storage.dart';

class DaftarMahasiswaService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<DaftarMahasiswa>> getListMahasiswa() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('Dosen ID not found in token storage');
      }
      final url = Uri.parse('${ApiConfig.baseUrl}/general/mahasiswa/$dosenId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => DaftarMahasiswa.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load list mahasiswa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching list mahasiswa: $e');
    }
  }
}