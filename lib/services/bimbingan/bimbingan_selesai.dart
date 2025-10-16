import 'dart:convert';

import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';

class SelesaiBimbinganService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();

  /// Menandai bimbingan mahasiswa sebagai selesai
  ///
  /// [mahasiswaId] - ID mahasiswa yang bimbingannya akan diselesaikan
  ///
  /// Returns [Future<bool>] - true jika berhasil, false jika gagal
  /// Throws [Exception] jika terjadi error
  Future<bool> selesaikanBimbingan(String mahasiswaId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/bimbingan/selesai/$mahasiswaId');

      final response = await _httpClient.patch(url);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Mahasiswa tidak ditemukan');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki akses untuk menyelesaikan bimbingan ini');
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'] ?? 'Gagal menyelesaikan bimbingan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan saat menyelesaikan bimbingan: ${e.toString()}');
    }
  }
}