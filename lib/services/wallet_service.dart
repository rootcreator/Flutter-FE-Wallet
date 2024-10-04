import 'api_service.dart';

class WalletService {
  // Fetch balance
  static Future<double?> fetchBalance() async {
    try {
      final response = await ApiService.getRequest('/balance');
      return response['balance'] != null ? response['balance'].toDouble() : null;
    } catch (e) {
      // Handle errors, maybe return null or default value
      print('Error fetching balance: $e');
      return null; // Return null in case of failure
    }
  }

  // Fetch account
  static Future<dynamic> fetchAccount() async {
    try {
      final response = await ApiService.getRequest('/account');
      return response['account'];
    } catch (e) {
      // Handle errors
      print('Error fetching account: $e');
      return null; // Return null in case of failure
    }
  }

  // Fetch transaction history
  static Future<List<dynamic>?> fetchTransactionHistory() async {
    try {
      final response = await ApiService.getRequest('/transactions');
      return response['transactions'] != null
          ? List<dynamic>.from(response['transactions'])
          : null;
    } catch (e) {
      // Handle errors
      print('Error fetching transaction history: $e');
      return null; // Return null in case of failure
    }
  }

  // Deposit money into the wallet
  static Future<dynamic> deposit(double amount) async {
    try {
      final response = await ApiService.postRequest('/deposit', {'amount': amount});
      return response; // Return the API response
    } catch (e) {
      // Handle errors
      print('Error depositing money: $e');
      return null; // Return null in case of failure
    }
  }

  // Withdraw money from the wallet
  static Future<dynamic> withdraw(double amount) async {
    try {
      final response = await ApiService.postRequest('/withdraw', {'amount': amount});
      return response; // Return the API response
    } catch (e) {
      // Handle errors
      print('Error withdrawing money: $e');
      return null; // Return null in case of failure
    }
  }

  // Transfer money to another user
  static Future<dynamic> transfer(double amount, String recipient) async {
    try {
      final response = await ApiService.postRequest('/transfer', {
        'amount': amount,
        'recipient': recipient,
      });
      return response; // Return the API response
    } catch (e) {
      // Handle errors
      print('Error transferring money: $e');
      return null; // Return null in case of failure
    }
  }
}