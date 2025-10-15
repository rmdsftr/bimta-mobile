import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/photo_profil.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'dart:convert';

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<ProfilePhoto> getPhotoProfile() async {
    try {
      // Ambil user_id dari token storage
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      // Panggil API dengan user_id
      final url = Uri.parse('${ApiConfig.baseUrl}/profil/foto/$userId');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        // Response berupa string URL langsung
        final photoUrl = response.body;

        // Jika response adalah string kosong atau "null", kembalikan ProfilePhoto kosong
        if (photoUrl.isEmpty || photoUrl == 'null') {
          return ProfilePhoto(photoUrl: null);
        }

        // Hapus tanda kutip jika ada
        final cleanedUrl = photoUrl.replaceAll('"', '');
        return ProfilePhoto(photoUrl: cleanedUrl);
      } else if (response.statusCode == 404) {
        return ProfilePhoto(photoUrl: null);
      } else {
        throw Exception('Gagal memuat foto profil: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting photo profile: $e');
      rethrow;
    }
  }

  Future<String?> getPhotoUrl() async {
    try {
      final profilePhoto = await getPhotoProfile();
      return profilePhoto.photoUrl;
    } catch (e) {
      print('Error getting photo URL: $e');
      return null;
    }
  }
}