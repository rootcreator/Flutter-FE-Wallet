import 'api_service.dart';

class SettingsService {
  // Fetch user profile information
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    final response = await ApiService.getRequest('/api/profile//');
    return response;
  }

  // Update user profile information
  static Future<dynamic> updateUserProfile(Map<String, dynamic> profileData) async {
    final response = await ApiService.postRequest('/api/profile/update', profileData);
    return response;
  }
}
