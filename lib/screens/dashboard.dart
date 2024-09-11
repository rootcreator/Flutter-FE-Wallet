import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/screens/transfer.dart';
import 'package:wallet/screens/withdraw.dart';
import '../providers/wallet_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_activity_list.dart';
import 'deposit.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, child) {
          return Column(
            children: [
              // Balance Card
              BalanceCard(balance: walletProvider.balance.balance),

              // Actions Row
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DepositScreen()));
                      },
                      child: Text('Deposit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen()));
                      },
                      child: Text('Transfer'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawScreen()));
                      },
                      child: Text('Withdraw'),
                    ),
                  ],
                ),
              ),

              // Recent Transactions
              Expanded(
                child: RecentActivityList(transactions: walletProvider.transactions),
              ),
            ],
          );
        },
      ),
    );
  }
}
