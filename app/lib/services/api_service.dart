import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.113:8000";

  static Future<int> predictHospital(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/predict");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      // Ambil nilai prediction (0/1) dari API
      return result["prediction"];
    } else {
      throw Exception("Failed to connect API: ${response.statusCode}");
    }
  }
}
