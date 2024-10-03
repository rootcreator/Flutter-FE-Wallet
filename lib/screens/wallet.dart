import 'package:flutter/material.dart';
import 'package:wallet/services/wallet_service.dart';
import 'package:wallet/widgets/transaction_dialog.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Future<double>? balanceFuture;
  Future<List<dynamic>>? transactionsFuture;

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
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    'Balance: \$${snapshot.data!.toStringAsFixed(2)}',
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
            FutureBuilder<List<dynamic>>(
              future: transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
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
                        title: Text(transaction['description']),
                        subtitle: Text(transaction['date']),
                        trailing: Text('\$${transaction['amount']}'),
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}