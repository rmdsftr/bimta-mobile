import 'dart:convert';

import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/response_jadwal.dart';

class JadwalResponseService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();

  /// Accept jadwal bimbingan
  Future<JadwalResponseModel> acceptBimbingan({
    required String bimbinganId,
    required DateTime datetime,
    String? message,
  }) async {
    try {
      // Format datetime to ISO 8601 string
      final datetimeString = datetime.toIso8601String();

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/jadwal/terima/$bimbinganId/$datetimeString',
      );

      final dto = ResponseJadwalDto(noteDosen: message);

      final response = await _httpClient.patch(
        url,
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return JadwalResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Jadwal tidak ditemukan');
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal menerima bimbingan');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// Reject jadwal bimbingan
  Future<JadwalResponseModel> rejectBimbingan({
    required String bimbinganId,
    required DateTime datetime,
    String? message,
  }) async {
    try {
      // Format datetime to ISO 8601 string
      final datetimeString = datetime.toIso8601String();

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/jadwal/tolak/$bimbinganId/$datetimeString',
      );

      final dto = ResponseJadwalDto(noteDosen: message);

      final response = await _httpClient.patch(
        url,
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return JadwalResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Jadwal tidak ditemukan');
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal menolak bimbingan');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<JadwalResponseModel> cancelBimbingan({
    required String bimbinganId,
    required DateTime datetime,
    String? message,
  }) async {
    try {
      // Format datetime to ISO 8601 string
      final datetimeString = datetime.toIso8601String();

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/jadwal/cancel/$bimbinganId/$datetimeString',
      );

      final dto = ResponseJadwalDto(noteDosen: message);

      final response = await _httpClient.patch(
        url,
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return JadwalResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Jadwal tidak ditemukan');
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal menolak bimbingan');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<JadwalResponseModel> doneBimbingan({
    required String bimbinganId,
    required DateTime datetime,
    String? message,
  }) async {
    try {
      // Format datetime to ISO 8601 string
      final datetimeString = datetime.toIso8601String();

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/jadwal/done/$bimbinganId/$datetimeString',
      );

      final dto = ResponseJadwalDto(noteDosen: message);

      final response = await _httpClient.patch(
        url,
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return JadwalResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Jadwal tidak ditemukan');
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal menolak bimbingan');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}