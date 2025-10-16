import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/add_jadwal_dosen.dart';
import 'package:bimta/services/auth/token_storage.dart';

class KegiatanService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Kegiatan> addKegiatan(AddKegiatanRequest request) async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/kegiatan/add/$dosenId');

      final response = await _httpClient.post(
        url,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Kegiatan.fromJson(jsonResponse);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal menambahkan kegiatan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<Kegiatan>> getKegiatanByMonth(int year, int month) async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      final url = Uri.parse(
          '${ApiConfig.baseUrl}/kegiatan/dosen/$dosenId?year=$year&month=$month'
      );

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Kegiatan.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengambil data kegiatan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<Kegiatan>> getKegiatanByDate(DateTime date) async {
    try {
      final userData = await _tokenStorage.getUserData();
      final dosenId = userData['user_id'];

      if (dosenId == null || dosenId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      final dateStr = date.toIso8601String().split('T')[0];
      final url = Uri.parse(
          '${ApiConfig.baseUrl}/kegiatan/dosen/$dosenId/date/$dateStr'
      );

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Kegiatan.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengambil data kegiatan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> deleteKegiatan(String jadwalDosenId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/kegiatan/$jadwalDosenId');

      final response = await _httpClient.delete(url);

      if (response.statusCode == 200) {
        return;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal menghapus kegiatan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}