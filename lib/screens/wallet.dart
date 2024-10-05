import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/services/wallet_service.dart';
import 'package:wallet/widgets/transaction_dialog.dart';
import 'package:wallet/models/transaction.dart'; // Import the Transaction model

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Future<double>? balanceFuture;
  Future<List<Transaction>>? transactionsFuture; // Use Transaction model

  @override
  void initState() {
    super.initState();
    balanceFuture = WalletService.fetchBalance();
    transactionsFuture = WalletService.fetchTransactionHistory();
  }

  void _openTransactionDialog(String operation) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(operation: operation);
      },
    ).then((value) {
      if (value == true) {
        setState(() {
          balanceFuture = WalletService.fetchBalance();
          transactionsFuture = WalletService.fetchTransactionHistory();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<double>(
              future: balanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Failed to load balance. Please try again.');
                } else {
                  return Text(
                    'Balance: \$${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _openTransactionDialog('Deposit'),
                  child: Text('Deposit'),
                ),
                ElevatedButton(
                  onPressed: () => _openTransactionDialog('Transfer'),
                  child: Text('Transfer'),
                ),
                ElevatedButton(
                  onPressed: () => _openTransactionDialog('Withdraw'),
                  child: Text('Withdraw'),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Transaction>>(
              future: transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Failed to load transactions. Please try again.');
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text('No transactions available');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var transaction = snapshot.data![index];
                      return ListTile(
                        title: Text(transaction.transactionType),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd – HH:mm').format(transaction.createdAt),
                        ),
                        trailing: Text(
                          '\$${NumberFormat("#,##0.00", "en_US").format(transaction.amount)}',
                          style: TextStyle(
                            color: transaction.amount < 0 ? Colors.red : Colors.green,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}