import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: FutureBuilder(
        future: walletProvider.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No transactions available"));
          }
          var transactions = snapshot.data as List;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index];
              return ListTile(
                title: Text("Transaction ${transaction['id']}"),
                subtitle: Text("Amount: ${transaction['amount']} ${transaction['currency']}"),
                trailing: Text(transaction['date']),
              );
            },
          );
        },
      ),
    );
  }
}
