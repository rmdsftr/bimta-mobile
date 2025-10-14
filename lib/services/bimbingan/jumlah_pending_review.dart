import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/services/auth/token_storage.dart';

class JumlahPendingReviewService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<int> getJumlahPendingReview() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('Dosen ID not found in token storage');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/progress/pending/$dosenId');
      print('Request URL: $url');

      final response = await _httpClient.get(url);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final int jumlah = json.decode(response.body) as int;
        return jumlah;
      } else {
        throw Exception('Failed to load jumlah mahasiswa: ${response.statusCode}');
      }
    } catch (e) {
      print('Error Exception: $e');
      throw Exception('Error fetching jumlah mahasiswa: $e');
    }
  }
}