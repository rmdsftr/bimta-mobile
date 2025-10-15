import 'dart:io';
import 'package:bimta/config/api.dart';
import 'package:bimta/models/ubah_foto.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'dart:convert';

class ProfilePhotoService {
  static final ProfilePhotoService _instance = ProfilePhotoService._internal();
  factory ProfilePhotoService() => _instance;
  ProfilePhotoService._internal();

  final TokenStorage _tokenStorage = TokenStorage();

  Future<ProfilePhotoResponse> changePhoto(File imageFile) async {
    try {
      // Get user_id from token storage
      final userData = await _tokenStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        return ProfilePhotoResponse.error('User ID tidak ditemukan');
      }

      // Get access token
      final token = await _tokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        return ProfilePhotoResponse.error('Token tidak ditemukan');
      }

      // Create multipart request
      final uri = Uri.parse('${ApiConfig.baseUrl}/profil/change/$userId');
      final request = http.MultipartRequest('PATCH', uri);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add file dengan mime type yang benar
      final bytes = await imageFile.readAsBytes();
      final fileName = imageFile.path.split('/').last;

      // Tentukan content type berdasarkan extension
      String contentType = 'image/jpeg'; // default
      if (fileName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.toLowerCase().endsWith('.jpg') ||
          fileName.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (fileName.toLowerCase().endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (fileName.toLowerCase().endsWith('.webp')) {
        contentType = 'image/webp';
      }

      // Parse content type menjadi type dan subtype
      final parts = contentType.split('/');

      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType(parts[0], parts[1]),
      );
      request.files.add(multipartFile);

      print('Uploading to: $uri');
      print('File size: ${bytes.length} bytes');
      print('File name: $fileName');
      print('Content type: $contentType');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Response adalah string URL langsung, bukan JSON
        final photoUrl = response.body;
        return ProfilePhotoResponse(
          success: true,
          photoUrl: photoUrl,
          message: 'Foto profil berhasil diubah',
        );
      } else {
        try {
          final error = json.decode(response.body);
          return ProfilePhotoResponse.error(
            error['message'] ?? 'Gagal mengubah foto profil (${response.statusCode})',
          );
        } catch (e) {
          return ProfilePhotoResponse.error(
            'Gagal mengubah foto profil (${response.statusCode})',
          );
        }
      }
    } catch (e) {
      print('Error uploading photo: $e');
      return ProfilePhotoResponse.error('Terjadi kesalahan: $e');
    }
  }
}