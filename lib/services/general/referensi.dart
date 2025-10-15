import 'dart:convert';
import 'package:bimta/config/api.dart';
import 'package:bimta/config/http_interceptor.dart';
import 'package:bimta/models/referensi.dart';

class GeneralService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();

  Future<List<ReferensiTa>> getReferensiTa() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/general/ta');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // DEBUG: Print raw response
        print('=== DEBUG RAW RESPONSE ===');
        print(jsonData);

        // DEBUG: Print first item to see structure
        if (jsonData.isNotEmpty) {
          print('=== DEBUG FIRST ITEM ===');
          print(jsonData[0]);
          print('doc_url value: ${jsonData[0]['doc_url']}');
        }

        return jsonData.map((json) => ReferensiTa.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load referensi TA: ${response.statusCode}');
      }
    } catch (e) {
      print('=== DEBUG ERROR ===');
      print(e);
      throw Exception('Error fetching referensi TA: $e');
    }
  }
}