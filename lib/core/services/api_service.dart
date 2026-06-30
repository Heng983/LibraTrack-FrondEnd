import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> postAuth(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAuth(String url) async {
    final headers = await _authHeaders();
    print('Token: ${await getToken()}');
    print('URL: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final headers = auth ? await _authHeaders() : _headers;
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteAuth(String url) async {
    final headers = await _authHeaders();
    print('DELETE URL: $url');
    print('Headers: $headers');
    final response = await http.delete(Uri.parse(url), headers: headers);
    print('DELETE Status: ${response.statusCode}');
    print('DELETE Body: ${response.body}');
    return jsonDecode(response.body);
  }
}
