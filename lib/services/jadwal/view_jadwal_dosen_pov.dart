import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/view_jadwal_dosen_pov.dart';
import 'package:bimta/services/auth/token_storage.dart';

class JadwalService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<JadwalBimbingan>> getJadwalDosen() async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      // Buat URL endpoint
      final url = Uri.parse('${ApiConfig.baseUrl}/jadwal/dosen/$dosenId');

      // Kirim request GET
      final response = await _httpClient.get(url);

      // Handle response
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => JadwalBimbingan.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else {
        throw Exception('Gagal memuat data jadwal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<List<JadwalBimbingan>> getJadwalByStatus(String status) async {
    try {
      final allJadwal = await getJadwalDosen();
      return allJadwal.where((jadwal) => jadwal.status == status).toList();
    } catch (e) {
      rethrow;
    }
  }
}