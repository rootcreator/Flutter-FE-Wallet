import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/screens/transfer.dart';
import 'package:wallet/screens/withdraw.dart';
import 'package:wallet/screens/deposit.dart';
import 'package:wallet/screens/link_account.dart'; // Import the new screen for linking account
import 'package:wallet/screens/link_wallet.dart'; // Import the new screen for linking wallet
import '../providers/wallet_provider.dart';
import '../services/auth.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_activity_list.dart';
import 'login.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  DashboardScreen({super.key}); // Initialize AuthService

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (!snapshot.hasData || snapshot.data == false) {
          // If not logged in, redirect to login screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const SizedBox.shrink(); // Return empty widget to avoid errors
        }

        // Continue to the dashboard if user is logged in
        return Scaffold(
          appBar: AppBar(
            title: const Text('Wallet Dashboard'),
            centerTitle: true,
          ),
          body: Consumer<WalletProvider>(
            builder: (context, walletProvider, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Balance Card
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BalanceCard(
                        balance: walletProvider.balance.balance,
                      ),
                    ),

                    // Action Buttons Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                context,
                                icon: Icons.account_balance_wallet,
                                label: 'Deposit',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const DepositScreen()));
                                },
                              ),
                              _buildActionButton(
                                context,
                                icon: Icons.send,
                                label: 'Transfer',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const TransferScreen()));
                                },
                              ),
                              _buildActionButton(
                                context,
                                icon: Icons.money_off,
                                label: 'Withdraw',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => WithdrawScreen()));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                context,
                                icon: Icons.link,
                                label: 'Link Account',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          LinkAccountScreen()));
                                },
                              ),
                              _buildActionButton(
                                context,
                                icon: Icons.link_outlined,
                                label: 'Link Wallet',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          LinkWalletScreen()));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Recent Transactions
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 300, // Limit the height for the transactions list
                      child: walletProvider.transactions.isNotEmpty
                          ? RecentActivityList(
                          transactions: walletProvider.transactions)
                          : const Center(
                        child: Text(
                          'No recent transactions',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Helper method to create action buttons
  Widget _buildActionButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

