import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/aktivitas_terkini_mahasiswa.dart';
import 'package:bimta/services/auth/token_storage.dart';

class AktivitasTerkiniService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<AktivitasTerkini>> getAktivitasTerkini() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final mahasiswaId = userData['user_id'];

      if (mahasiswaId == null || mahasiswaId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/general/terkini/mahasiswa/$mahasiswaId');

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => AktivitasTerkini.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat aktivitas terkini: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in AktivitasTerkiniService: $e');
      rethrow;
    }
  }
}