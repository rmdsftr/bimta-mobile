import 'dart:io';
import 'package:bimta/config/api.dart';
import 'package:bimta/models/progress_online.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bimta/services/auth/token_storage.dart';
import 'package:http_parser/http_parser.dart';

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  final TokenStorage _tokenStorage = TokenStorage();

  Future<ProgressResponse> addProgressOnline({
    required String subjectProgress,
    required String noteMahasiswa,
    required File pdfFile,
  }) async {
    try {
      // Get user_id from token storage
      final userData = await _tokenStorage.getUserData();
      final mahasiswaId = userData['user_id'];

      if (mahasiswaId == null || mahasiswaId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Silakan login kembali.');
      }

      // Get access token
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      // Prepare multipart request
      final uri = Uri.parse('${ApiConfig.baseUrl}/progress/add/$mahasiswaId');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add fields
      request.fields['subject_progress'] = subjectProgress;
      request.fields['note_mahasiswa'] = noteMahasiswa;

      // Add file
      final fileStream = http.ByteStream(pdfFile.openRead());
      final fileLength = await pdfFile.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: pdfFile.path.split('/').last,
        contentType: MediaType('application', 'pdf'),
      );
      request.files.add(multipartFile);

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return ProgressResponse.fromJson(jsonResponse);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Gagal mengirim progress');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}