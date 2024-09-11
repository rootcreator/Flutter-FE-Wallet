import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/wallet_balance.dart';
import '../models/transaction.dart';

class ApiService {
  static Future<WalletBalance> fetchBalanceFromApi() async {
    final response = await http.get(Uri.parse('YOUR_BACKEND_URL/balance'));
    if (response.statusCode == 200) {
      return WalletBalance(balance: double.parse(response.body));
    } else {
      throw Exception('Failed to load balance');
    }
  }

  static Future<List<Transaction>> fetchTransactionsFromApi() async {
    final response = await http.get(Uri.parse('YOUR_BACKEND_URL/transactions'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Transaction(
        id: item['id'],
        amount: item['amount'],
        date: DateTime.parse(item['date']),
        type: item['type'],
      )).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
