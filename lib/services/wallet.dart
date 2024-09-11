import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> deposit(double amount) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      Response response = await _dio.post(
        'http://127.0.0.1:8000/api/deposit/',
        data: {
          'amount': amount,
          'currency': 'USD',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<bool> withdraw(double amount) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      Response response = await _dio.post(
        'http://127.0.0.1:8000/api/withdraw/',
        data: {
          'amount': amount,
          'currency': 'USD',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<bool> transfer(double amount, String destinationWalletId) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      Response response = await _dio.post(
        'http://127.0.0.1:8000/api/transfer/',
        data: {
          'amount': amount,
          'destination_wallet_id': destinationWalletId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<List<dynamic>> getTransactions() async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      Response response = await _dio.get(
        'http://127.0.0.1:8000/api/transactions/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data['transactions'];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
