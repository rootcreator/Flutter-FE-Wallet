import 'package:flutter/material.dart';
import '../services/wallet.dart';
import '../models/wallet_balance.dart';
import '../models/transaction.dart';
import '../utils/api.dart';

class WalletProvider with ChangeNotifier {
  WalletBalance _balance = WalletBalance(balance: 0.0);
  List<Transaction> _transactions = [];
  final WalletService _walletService = WalletService();

  WalletBalance get balance => _balance;
  List<Transaction> get transactions => _transactions;

  // Fetch wallet balance and transaction history from the API
  Future<void> fetchWalletData() async {
    try {
      _balance = await ApiService.fetchBalanceFromApi();
      _transactions = await ApiService.fetchTransactionsFromApi();
      notifyListeners();
    } catch (e) {
      print('Error fetching wallet data: $e');
      // Handle error (e.g., show error message in the UI)
    }
  }

  // Deposit into the wallet
  Future<bool> deposit(double amount) async {
    try {
      bool success = await _walletService.deposit(amount);
      if (success) {
        await fetchWalletData();  // Refresh data only if deposit is successful
      }
      return success;
    } catch (e) {
      print('Deposit failed: $e');
      return false;
    }
  }

  // Withdraw from the wallet
  Future<bool> withdraw(double amount) async {
    try {
      bool success = await _walletService.withdraw(amount);
      if (success) {
        await fetchWalletData();  // Refresh data only if withdrawal is successful
      }
      return success;
    } catch (e) {
      print('Withdraw failed: $e');
      return false;
    }
  }

  // Transfer to another wallet
  Future<bool> transfer(double amount, String destinationWalletId) async {
    try {
      bool success = await _walletService.transfer(amount, destinationWalletId);
      if (success) {
        await fetchWalletData();  // Refresh data only if transfer is successful
      }
      return success;
    } catch (e) {
      print('Transfer failed: $e');
      return false;
    }
  }

  // Retrieve transaction history from the API
  Future<List<dynamic>> getTransactions() async {
    try {
      return await _walletService.getTransactions();
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }
}
