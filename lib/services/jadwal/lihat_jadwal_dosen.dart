import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/lihat_jadwal_dosen.dart';
import 'package:bimta/services/auth/token_storage.dart';

class KegiatanService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<KegiatanModel>> getKegiatanByBulan({
    required int year,
    required int month,
  }) async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final mahasiswaId = userData['user_id'];

      if (mahasiswaId == null || mahasiswaId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/kegiatan/mahasiswa/$mahasiswaId?year=$year&month=$month',
      );

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final dynamic responseBody = json.decode(response.body);

        // Handle jika response adalah object dengan property data
        List<dynamic> jsonData;
        if (responseBody is Map && responseBody.containsKey('data')) {
          jsonData = responseBody['data'] as List<dynamic>;
        } else if (responseBody is List) {
          jsonData = responseBody;
        } else {
          return [];
        }

        return jsonData
            .map((json) => KegiatanModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi login telah berakhir');
      } else {
        throw Exception('Gagal mengambil data kegiatan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getKegiatanByBulan: $e');
      rethrow;
    }
  }

  /// Mengambil kegiatan berdasarkan tanggal tertentu
  Future<List<KegiatanModel>> getKegiatanByTanggal({
    required DateTime date,
  }) async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final mahasiswaId = userData['user_id'];

      if (mahasiswaId == null || mahasiswaId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      // Format tanggal ke ISO 8601
      final dateString = date.toIso8601String();

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/kegiatan/mahasiswa/$mahasiswaId/date/$dateString',
      );

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final dynamic responseBody = json.decode(response.body);

        // Handle jika response adalah object dengan property data
        List<dynamic> jsonData;
        if (responseBody is Map && responseBody.containsKey('data')) {
          jsonData = responseBody['data'] as List<dynamic>;
        } else if (responseBody is List) {
          jsonData = responseBody;
        } else {
          return [];
        }

        return jsonData
            .map((json) => KegiatanModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi login telah berakhir');
      } else {
        throw Exception('Gagal mengambil data kegiatan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getKegiatanByTanggal: $e');
      rethrow;
    }
  }

  /// Konversi kegiatan ke Map untuk calendar
  Map<DateTime, List<KegiatanModel>> convertToCalendarMap(
      List<KegiatanModel> kegiatanList,
      ) {
    final Map<DateTime, List<KegiatanModel>> calendarMap = {};

    for (var kegiatan in kegiatanList) {
      // Normalize tanggal (set time to midnight)
      final normalizedDate = DateTime(
        kegiatan.tanggal.year,
        kegiatan.tanggal.month,
        kegiatan.tanggal.day,
      );

      if (calendarMap.containsKey(normalizedDate)) {
        calendarMap[normalizedDate]!.add(kegiatan);
      } else {
        calendarMap[normalizedDate] = [kegiatan];
      }
    }

    return calendarMap;
  }
}