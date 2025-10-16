import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/riwayat_mahasiswa.dart';
import 'package:bimta/services/auth/token_storage.dart';

class RiwayatService {
  static final RiwayatService _instance = RiwayatService._internal();
  factory RiwayatService() => _instance;
  RiwayatService._internal();

  final TokenStorage _tokenStorage = TokenStorage();
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();

  Future<List<RiwayatBimbinganModel>> getRiwayatBimbingan({String? mahasiswaId}) async {
    try {
      mahasiswaId ??= (await _tokenStorage.getUserData())['user_id'];

      if (mahasiswaId == null) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/riwayat/$mahasiswaId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final List<dynamic> dataList = responseData is List ? responseData : responseData['data'] ?? [];

        final riwayatList = dataList
            .map((item) => RiwayatBimbinganModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // Sort by tanggal descending (terbaru dahulu)
        riwayatList.sort((a, b) => b.tanggal.compareTo(a.tanggal));

        return riwayatList;
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Data riwayat bimbingan tidak ditemukan');
      } else {
        throw Exception('Gagal mengambil data riwayat bimbingan');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}