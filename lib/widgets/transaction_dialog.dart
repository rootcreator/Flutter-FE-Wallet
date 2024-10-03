import 'package:flutter/material.dart';
import 'package:wallet/services/wallet_service.dart';

class TransactionDialog extends StatefulWidget {
  final String operation; // Deposit, Transfer, or Withdraw

  TransactionDialog({required this.operation});

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController(); // For transfers
  bool isLoading = false;

  // Handle transaction submission
  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    double amount = double.parse(_amountController.text);
    bool success;

    try {
      if (widget.operation == 'Deposit') {
        success = await WalletService.deposit(amount);
      } else if (widget.operation == 'Transfer') {
        String recipient = _recipientController.text;
        success = await WalletService.transfer(amount, recipient);
      } else if (widget.operation == 'Withdraw') {
        success = await WalletService.withdraw(amount);
      } else {
        success = false;
      }

      if (success) {
        Navigator.of(context).pop(true); // Close the dialog and refresh the page
      } else {
        _showError('Transaction failed.');
      }
    } catch (e) {
      _showError('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.operation} Funds'),
      content: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            if (widget.operation == 'Transfer')
              TextFormField(
                controller: _recipientController,
                decoration: InputDecoration(labelText: 'Recipient'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipient';
                  }
                  return null;
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitTransaction,
          child: Text(widget.operation),
        ),
      ],
    );
  }
}
