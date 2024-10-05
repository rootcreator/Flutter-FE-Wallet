import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Replace with actual base URL
  static String? _token; // Private token variable

  // Fetch the saved token or load it from Shared Preferences
  static Future<void> _loadToken() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
    }
  }

  // Common headers for API requests
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_token ?? ''}', // Use token if available
    };
  }

  // Save token and expiry to Shared Preferences
  static Future<void> _saveToken(String token, DateTime expiry) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('token_expiry', expiry.toIso8601String());
  }

  // Check if the token is valid by comparing expiry
  static Future<bool> _isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString('token_expiry');
    if (expiryString != null) {
      final expiry = DateTime.parse(expiryString);
      return DateTime.now().isBefore(expiry);
    }
    return false;
  }

  // Clear token and expiry from Shared Preferences
  static Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('token_expiry');
    _token = null;
  }

  // Ensure token validity before making API calls
  static Future<void> _ensureTokenValid() async {
    await _loadToken();
    if (!await _isTokenValid()) {
      await _clearToken(); // Clear expired token
      throw Exception('Session expired. Please log in again.');
    }
  }

  // Login method
  static Future<dynamic> login(String email, String password) async {
    final response = await _postRequest('auth/login/', {
      'email': email,
      'password': password,
    });

    if (response['token'] != null) {
      final tokenExpiry = DateTime.now().add(Duration(hours: 10)); // Example: 10 hours
      await _saveToken(response['token'], tokenExpiry); // Save token and expiry
    }
    return response;
  }

  // Logout method
  static Future<void> logout() async {
    await _postRequest('logout/', {});
    await _clearToken();
  }

  // Logout all sessions method
  static Future<void> logoutAll() async {
    await _postRequest('logoutall/', {});
    await _clearToken();
  }

  // Register method
  static Future<dynamic> register(String username, String email, String password) async {
    final response = await _postRequest('register/', {
      'username': username,
      'email': email,
      'password': password,
    });

    if (response['token'] != null) {
      final tokenExpiry = DateTime.now().add(Duration(hours: 10));
      await _saveToken(response['token'], tokenExpiry);
    }
    return response;
  }

  // Fetch KYC information
  static Future<dynamic> fetchKYC() async {
    return await _getRequest('kyc/');
  }

  // Password reset request
  static Future<dynamic> passwordResetRequest(String email) async {
    return await _postRequest('password-reset/', {'email': email});
  }

  // Password reset confirmation
  static Future<dynamic> passwordResetConfirm(String uidb64, String token, String newPassword) async {
    return await _postRequest('password-reset-confirm/$uidb64/$token/', {'new_password': newPassword});
  }

  // GET request method
  static Future<dynamic> _getRequest(String endpoint) async {
    await _ensureTokenValid(); // Ensure token is valid before making request

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _getHeaders(),
    );
    return _processResponse(response);
  }

  // POST request method
  static Future<dynamic> _postRequest(String endpoint, Map<String, dynamic> body) async {
    await _ensureTokenValid();

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _getHeaders(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Process API responses
  static dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorMessage = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw Exception('Failed to load data: $errorMessage (Status code: ${response.statusCode})');
    }
  }
}