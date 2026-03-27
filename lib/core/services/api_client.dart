import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const bool _isEmulator = false;

  static const String baseUrl = _isEmulator
      ? 'http://10.0.2.2:5000'
      : 'http://192.168.8.109:5000';

  static Future<Map<String, String>> _authHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');
    final token = await user.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String path, {int retries = 3}) async {
    final headers = await _authHeaders();
    final url = Uri.parse('$baseUrl$path');

    for (int i = 0; i < retries; i++) {
      try {
        return await http
            .get(url, headers: headers)
            .timeout(const Duration(seconds: 15));
      } catch (e) {
        if (i == retries - 1) rethrow;
        await Future.delayed(Duration(seconds: 1 * (i + 1)));
      }
    }
    throw Exception('Failed to get $path after $retries retries');
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders();
    return http
        .post(
          Uri.parse('$baseUrl$path'),
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
  }

  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders();
    return http
        .put(
          Uri.parse('$baseUrl$path'),
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
  }
}
