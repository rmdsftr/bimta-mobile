import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/bimbingan_online_dosen.dart';
import 'package:bimta/services/auth/token_storage.dart';

class ProgressOnlineService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<ProgressOnlineModel>> getProgressOnlineMahasiswa() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/progress/dosen/$dosenId');

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((item) => ProgressOnlineModel.fromJson(item))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}