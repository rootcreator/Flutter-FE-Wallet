import 'api_service.dart';

class WalletService {
  // Fetch balance
  static Future<double> fetchBalance() async {
    final response = await ApiService.getRequest('/balance');
    return response['balance'];
  }

  // Fetch account
  static Future<void> fetchAccount() async {
    final response = await ApiService.getRequest('/account');
    return response['account'];
  }

  // Fetch transaction history
  static Future<List<dynamic>> fetchTransactionHistory() async {
    final response = await ApiService.getRequest('/transactions');
    return response['transactions'];
  }

  // Deposit money into the wallet
  static Future<dynamic> deposit(double amount) async {
    final response = await ApiService.postRequest('/deposit', {'amount': amount});
    return response; // Return the API response
  }

  // Withdraw money from the wallet
  static Future<dynamic> withdraw(double amount) async {
    final response = await ApiService.postRequest('/withdraw', {'amount': amount});
    return response; // Return the API response
  }

  // Transfer money to another user
  static Future<dynamic> transfer(double amount, String recipient) async {
    final response = await ApiService.postRequest('/transfer', {
      'amount': amount,
      'recipient': recipient,
    });
    return response; // Return the API response
  }
}
