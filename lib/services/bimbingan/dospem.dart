import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/services/auth/token_storage.dart';

class DospemService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<Dospem>> getDospem() async {
    try {
      final userData = await _tokenStorage.getUserData();
      final mahasiswaId = userData['user_id'];

      if (mahasiswaId == null || mahasiswaId.isEmpty) {
        throw Exception('Mahasiswa ID not found in token storage');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/bimbingan/dospem/$mahasiswaId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Dospem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load dosen pembimbing: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dosen pembimbing: $e');
    }
  }
}

class Dospem {
  final String nama;

  Dospem({
    required this.nama,
  });

  factory Dospem.fromJson(Map<String, dynamic> json) {
    return Dospem(
      nama: json['users_bimbingan_dosen_idTousers']['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
    };
  }
}