import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class TransferScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _destinationIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Transfer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _destinationIdController,
              decoration: InputDecoration(labelText: "Destination Wallet ID"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                double amount = double.tryParse(_amountController.text) ?? 0.0;
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
              },
              child: Text("Transfer"),
            ),
          ],
        ),
      ),
    );
  }
}
