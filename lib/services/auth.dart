import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio();
  final storage = const FlutterSecureStorage();

  Future<bool> register(String username, String email, String password) async {
    try {
      Response response = await _dio.post(
        'http://127.0.0.1:8000/api/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 201) {
        String token = response.data['token'];
        await storage.write(key: 'auth_token', value: token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error during registration: $e");
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        'http://127.0.0.1:8000/api/login/',
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        String token = response.data['token'];
        await storage.write(key: 'auth_token', value: token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      String? token = await getToken();
      if (token == null) return true;

      Response response = await _dio.post(
        'http://127.0.0.1:8000/api/logout/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        await storage.delete(key: 'auth_token');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error during logout: $e");
      return false;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  // For JWT implementation
  Future<bool> refreshToken() async {
    try {
      String? refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      Response response = await _dio.post(
        'http://127.0.0.1:8000/api/token/refresh/',
        data: {
          'refresh': refreshToken,
        },
      );
      if (response.statusCode == 200) {
        String newAccessToken = response.data['access'];
        await storage.write(key: 'auth_token', value: newAccessToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  }
}