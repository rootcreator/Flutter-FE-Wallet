import 'api_service.dart';
import 'logger.dart'; // Assuming you have a logger setup
import 'account.dart'; // Your Account model
import 'transaction.dart'; // Your Transaction model

class WalletService {
  // Fetch balance
  static Future<double?> fetchBalance() async {
    try {
      final response = await ApiService.getRequest('/balance');
      return response['balance']?.toDouble();
    } catch (e) {
      logger.e('Error fetching balance: $e');
      throw Exception('Error fetching balance');
    }
  }

  // Fetch account
  static Future<Account?> fetchAccount() async {
    try {
      final response = await ApiService.getRequest('/account');
      return Account.fromJson(response['account']);
    } catch (e) {
      logger.e('Error fetching account: $e');
      throw Exception('Error fetching account');
    }
  }

  // Fetch transaction history
  static Future<List<Transaction>?> fetchTransactionHistory() async {
    try {
      final response = await ApiService.getRequest('/transactions');
      if (response['transactions'] is List) {
        return List<Transaction>.from(
          response['transactions'].map((tx) => Transaction.fromJson(tx))
        );
      }
      return [];
    } catch (e) {
      logger.e('Error fetching transaction history: $e');
      throw Exception('Error fetching transaction history');
    }
  }

  // Deposit money into the wallet
  static Future<dynamic> deposit(double amount) async {
    try {
      final response = await ApiService.postRequest('/deposit', {'amount': amount});
      return response;
    } catch (e) {
      logger.e('Error depositing money: $e');
      throw Exception('Error depositing money');
    }
  }

  // Withdraw money from the wallet
  static Future<dynamic> withdraw(double amount) async {
    try {
      final response = await ApiService.postRequest('/withdraw', {'amount': amount});
      return response;
    } catch (e) {
      logger.e('Error withdrawing money: $e');
      throw Exception('Error withdrawing money');
    }
  }

  // Transfer money to another user
  static Future<dynamic> transfer(double amount, String recipient) async {
    try {
      final response = await ApiService.postRequest('/transfer', {
        'amount': amount,
        'recipient': recipient,
      });
      return response;
    } catch (e) {
      logger.e('Error transferring money: $e');
      throw Exception('Error transferring money');
    }
  }
}