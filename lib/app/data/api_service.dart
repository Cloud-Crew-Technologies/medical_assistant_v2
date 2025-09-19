import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.195.18.38:3000';

  static Future<String> getToken() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/token'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'] as String;
      } else {
        throw Exception('Failed to get token: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching token: $e');
    }
  }
}
