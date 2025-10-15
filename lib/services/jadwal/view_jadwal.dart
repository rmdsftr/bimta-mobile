import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/view_jadwal.dart';
import 'package:bimta/services/auth/token_storage.dart';

class JadwalService {
  static final JadwalService _instance = JadwalService._internal();
  factory JadwalService() => _instance;
  JadwalService._internal();

  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<JadwalModel>> viewJadwal() async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final mahasiswaId = userData['user_id'];

      if (mahasiswaId == null || mahasiswaId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      // Buat URL endpoint
      final url = Uri.parse('${ApiConfig.baseUrl}/jadwal/view/$mahasiswaId');

      // Kirim request GET
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => JadwalModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Tidak ada data jadwal
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else {
        throw Exception('Gagal memuat jadwal: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
      }
      rethrow;
    }
  }

  // Filter jadwal berdasarkan status
  List<JadwalModel> filterByStatus(List<JadwalModel> jadwalList, String status) {
    return jadwalList.where((jadwal) => jadwal.status.toLowerCase() == status.toLowerCase()).toList();
  }

  // Hitung jumlah jadwal per status
  Map<String, int> getStatusCount(List<JadwalModel> jadwalList) {
    return {
      'waiting': jadwalList.where((j) => j.status.toLowerCase() == 'waiting').length,
      'accepted': jadwalList.where((j) => j.status.toLowerCase() == 'accepted').length,
      'declined': jadwalList.where((j) => j.status.toLowerCase() == 'declined').length,
    };
  }
}