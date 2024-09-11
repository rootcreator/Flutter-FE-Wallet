import 'package:flutter/material.dart';
import '../models/transaction.dart';

class RecentActivityList extends StatelessWidget {
  final List<Transaction> transactions;

  RecentActivityList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return ListTile(
          leading: Icon(tx.type == 'deposit' ? Icons.arrow_upward : Icons.arrow_downward),
          title: Text('Transaction #${tx.id}'),
          subtitle: Text('${tx.date.toLocal()} - \$${tx.amount}'),
        );
      },
    );
  }
}
