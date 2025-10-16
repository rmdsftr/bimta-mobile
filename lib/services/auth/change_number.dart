import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/change_number.dart';
import 'package:bimta/services/auth/token_storage.dart';

class ProfileService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  /// Mengubah nomor WhatsApp user
  Future<ChangeNumberResponse> changeNumber(String newNumber) async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      // Buat request body
      final request = ChangeNumberRequest(nomorBaru: newNumber);

      // Endpoint URL
      final url = Uri.parse('${ApiConfig.baseUrl}/profil/changeNumber/$userId');

      // Kirim PATCH request
      final response = await _httpClient.patch(
        url,
        body: jsonEncode(request.toJson()),
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return ChangeNumberResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal mengubah nomor WhatsApp');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// Validasi format nomor HP
  bool validatePhoneNumber(String phone) {
    // Hapus spasi dan karakter non-digit
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Minimal 10 digit, maksimal 15 digit
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return false;
    }

    // Harus dimulai dengan 08 atau 628
    return cleanPhone.startsWith('08') || cleanPhone.startsWith('628');
  }

  /// Format nomor HP ke format standar (62xxx)
  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    } else if (!cleanPhone.startsWith('62')) {
      cleanPhone = '62$cleanPhone';
    }

    return cleanPhone;
  }
}