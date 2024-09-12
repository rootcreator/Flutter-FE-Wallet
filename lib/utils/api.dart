import 'package:dio/dio.dart';
import '../models/wallet_balance.dart';
import '../models/transaction.dart';

class ApiService {
  static final Dio _dio = Dio();

  static Future<WalletBalance> fetchBalanceFromApi() async {
    try {
      final response = await _dio.get('http://127.0.0.1:8000/api/balance/');
      if (response.statusCode == 200) {
        // Assuming the API returns a JSON object with a balance key
        final data = response.data;
        return WalletBalance(balance: data['balance']);
      } else {
        throw Exception('Failed to load balance');
      }
    } catch (e) {
      print("Fetch Balance Error: $e");
      throw Exception('Failed to load balance');
    }
  }

  static Future<List<Transaction>> fetchTransactionsFromApi() async {
    try {
      final response = await _dio.get('http://127.0.0.1:8000/api/transactions/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => Transaction(
          id: item['id'],
          amount: item['amount'],
          date: DateTime.parse(item['date']),
          type: item['type'],
        )).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print("Fetch Transactions Error: $e");
      throw Exception('Failed to load transactions');
    }
  }
}
