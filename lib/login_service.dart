import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String apiUrl =
      'http://127.0.0.1/smartstock-app/backend/login.php'; // Replace with correct local server URL

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return decoded response as a map
    } else {
      throw Exception('Failed to load login response');
    }
  }
}
