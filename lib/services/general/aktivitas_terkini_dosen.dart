import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/aktivitas_terkini_dosen.dart';
import 'package:bimta/services/auth/token_storage.dart';

class AktivitasTerkiniService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<AktivitasTerkini>> getAktivitasTerkini() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/general/terkini/dosen/$userId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => AktivitasTerkini.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else {
        throw Exception('Gagal memuat aktivitas terkini: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAktivitasTerkini: $e');
      rethrow;
    }
  }
}