import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/get_progress.dart';
import 'package:bimta/services/auth/token_storage.dart';

class ProgressService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<ProgressModel>> getAllProgressOnline() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/progress/$userId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => ProgressModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else if (response.statusCode == 404) {
        throw Exception('Bimbingan tidak ditemukan untuk mahasiswa ini');
      } else {
        throw Exception('Gagal mengambil data progress: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllProgressOnline: $e');
      rethrow;
    }
  }

  Future<List<ProgressModel>> getProgressByStatus(String status) async {
    try {
      final allProgress = await getAllProgressOnline();
      return allProgress.where((progress) => progress.status == status).toList();
    } catch (e) {
      print('Error in getProgressByStatus: $e');
      rethrow;
    }
  }
}