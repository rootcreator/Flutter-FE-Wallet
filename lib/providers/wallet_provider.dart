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

  Future<void> fetchWalletData() async {
    _balance = await ApiService.fetchBalanceFromApi();
    _transactions = await ApiService.fetchTransactionsFromApi();
    notifyListeners();
  }

  Future<bool> deposit(double amount) async {
    return await _walletService.deposit(amount);
  }

  Future<bool> withdraw(double amount) async {
    return await _walletService.withdraw(amount);
  }

  Future<bool> transfer(double amount, String destinationWalletId) async {
    return await _walletService.transfer(amount, destinationWalletId);
  }

  Future<List<dynamic>> getTransactions() async {
    return await _walletService.getTransactions();
  }
}
