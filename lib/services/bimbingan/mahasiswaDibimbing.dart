import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/mahasiswa_dibimbing.dart';
import 'package:bimta/services/auth/token_storage.dart';

class MahasiswaDibimbingService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<MahasiswaDibimbing>> getMahasiswaDibimbing() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('Dosen ID not found in token storage');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/bimbingan/$dosenId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => MahasiswaDibimbing.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load mahasiswa dibimbing: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching mahasiswa dibimbing: $e');
    }
  }
}