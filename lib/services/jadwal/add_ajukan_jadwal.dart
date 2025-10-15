import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/add_ajukan_jadwal.dart';
import 'package:bimta/services/auth/token_storage.dart';

class JadwalService {
  static final JadwalService _instance = JadwalService._internal();
  factory JadwalService() => _instance;
  JadwalService._internal();

  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<AddJadwalResponse> addJadwal(AddJadwalRequest request) async {
    try {
      final userData = await _tokenStorage.getUserData();
      final mahasiswaId = userData['user_id'];

      if (mahasiswaId == null || mahasiswaId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/jadwal/add/$mahasiswaId');

      final response = await _httpClient.post(
        url,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return AddJadwalResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        throw Exception('Bimbingan tidak ditemukan untuk mahasiswa ini');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = _getErrorMessage(response);
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gagal mengirim data: ${e.toString()}');
    }
  }

  String _getErrorMessage(response) {
    try {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['message'] ?? 'Terjadi kesalahan pada server';
    } catch (e) {
      return 'Terjadi kesalahan pada server';
    }
  }
}