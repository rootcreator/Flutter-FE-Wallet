import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _destinationIdController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Transfer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount greater than 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _destinationIdController,
                decoration: InputDecoration(labelText: "Destination Wallet ID"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination wallet ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            _isLoading = true;
                          });

                          double amount = double.parse(_amountController.text);
                          String destinationWalletId = _destinationIdController.text;
                          bool success = await walletProvider.transfer(amount, destinationWalletId);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Transfer successful")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Transfer failed")),
                            );
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: Text("Transfer"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}