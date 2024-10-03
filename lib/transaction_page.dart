import 'package:flutter/material.dart';
import 'package:wallet/services/wallet_service.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  String _transactionType = 'Deposit';

  void _performTransaction() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    String recipient = _recipientController.text;

    if (amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    if (_transactionType == 'Transfer' && recipient.isEmpty) {
      _showError('Please enter a recipient');
      return;
    }

    try {
      if (_transactionType == 'Deposit') {
        await WalletService.deposit(amount); // Implement this method in WalletService
        _showSuccess('Deposit successful!');
      } else if (_transactionType == 'Withdraw') {
        await WalletService.withdraw(amount); // Implement this method in WalletService
        _showSuccess('Withdrawal successful!');
      } else if (_transactionType == 'Transfer') {
        await WalletService.transfer(amount, recipient); // Implement this method in WalletService
        _showSuccess('Transfer successful!');
      }

      // Clear the input fields after the transaction
      _amountController.clear();
      _recipientController.clear();
    } catch (e) {
      _showError('Transaction failed: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.green))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transaction Type', style: TextStyle(fontSize: 20)),
          DropdownButton<String>(
            value: _transactionType,
            items: ['Deposit', 'Withdraw', 'Transfer']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _transactionType = value!;
              });
            },
          ),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          if (_transactionType == 'Transfer')
            TextField(
              controller: _recipientController,
              decoration: InputDecoration(labelText: 'Recipient Address'),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _performTransaction,
            child: Text('Submit Transaction'),
          ),
        ],
      ),
    );
  }
}
