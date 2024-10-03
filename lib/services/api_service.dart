import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Replace with actual base URL
  static String? _token; // Private token variable

  // Common headers for API requests
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_token ?? ''}', // Use token if available
    };
  }

  // Save token to Shared Preferences
  static Future<void> saveToken(String token) async {
    _token = token; // Store token in the private variable
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Save token to shared preferences
  }

  // Get token from Shared Preferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Retrieve token from shared preferences
  }

  // Load token from Shared Preferences
  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token'); // Retrieve token from shared preferences
  }

  // Clear token from Shared Preferences
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Remove token from shared preferences
    _token = null; // Clear the private variable
  }

  // Login method
  static Future<dynamic> login(String email, String password) async {
    final response = await postRequest('auth', {
      'email': email,
      'password': password,
    });

    // Save token after successful login
    if (response['token'] != null) {
      await saveToken(response['token']);
    }
    return response;
  }

  // Logout method
  static Future<void> logout() async {
    await postRequest('logout/', {}); // Send a POST request to logout
    await clearToken(); // Clear token after logging out
  }

  // Logout all method
  static Future<void> logoutAll() async {
    await postRequest('logoutall/', {}); // Send a POST request to logout from all sessions
    await clearToken(); // Clear token after logging out from all
  }

  // Registration method
  static Future<dynamic> register(String username, String email, String password) async {
    final response = await postRequest('register/', {
      'username': username,
      'email': email,
      'password': password,
    });

    // Save token after successful registration
    if (response['token'] != null) {
      await saveToken(response['token']);
    }
    return response;
  }

  // Password reset request
  static Future<dynamic> passwordResetRequest(String email) async {
    return await postRequest('password-reset/', {
      'email': email,
    });
  }

  // Password reset confirm
  static Future<dynamic> passwordResetConfirm(String uidb64, String token, String newPassword) async {
    final response = await postRequest('password-reset-confirm/$uidb64/$token/', {
      'new_password': newPassword,
    });
    return response; // Return response for confirmation
  }

  // Get Request
  static Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: getHeaders(),
    );
    return _processResponse(response);
  }

  // Post Request
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: getHeaders(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Process API Response
  static dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
