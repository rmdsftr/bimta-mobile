import 'dart:convert';

import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/setuju_ganti_model.dart';

class ApproveJudulService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();

  /// Menyetujui perubahan judul TA mahasiswa
  /// Backend akan memindahkan judul_temp ke judul dan mengosongkan judul_temp
  Future<ApproveJudulResponse> approveJudul(String mahasiswaId) async {
    try {
      // Panggil API
      final url = Uri.parse('${ApiConfig.baseUrl}/profil/accJudul/$mahasiswaId');
      final response = await _httpClient.patch(url);

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Backend mengembalikan true
        final data = jsonDecode(response.body);

        if (data == true || data is bool && data) {
          return ApproveJudulResponse(
            success: true,
            message: 'Perubahan judul TA berhasil disetujui',
          );
        }

        return ApproveJudulResponse(
          success: true,
          message: 'Perubahan judul TA berhasil disetujui',
        );
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Data tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Mahasiswa tidak ditemukan');
      } else if (response.statusCode == 500) {
        throw Exception('Terjadi kesalahan pada server');
      } else {
        throw Exception('Gagal menyetujui perubahan judul. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApproveJudulResponse> rejectJudul(String mahasiswaId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/profil/rejectJudul/$mahasiswaId');
      final response = await _httpClient.patch(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApproveJudulResponse(
          success: true,
          message: 'Perubahan judul TA tidak disetujui',
        );
      } else {
        throw Exception('Gagal menolak perubahan judul');
      }

    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}