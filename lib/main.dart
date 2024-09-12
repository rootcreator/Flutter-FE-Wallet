import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/wallet_provider.dart';
import './screens/login.dart';
import './screens/dashboard.dart';
import './screens/deposit.dart';
import './screens/withdraw.dart';
import './screens/transfer.dart';
import './screens/transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: MaterialApp(
        title: 'Wallet App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          Routes.initialRoute: (context) => Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return authProvider.isAuthenticated
                  ? DashboardScreen()
                  : LoginScreen();
            },
          ),
          Routes.dashboardRoute: (context) => DashboardScreen(),
          Routes.depositRoute: (context) => DepositScreen(),
          Routes.withdrawRoute: (context) => WithdrawScreen(),
          Routes.transferRoute: (context) => TransferScreen(),
          Routes.transactionsRoute: (context) => TransactionsScreen(),
        },
      ),
    );
  }
}

class Routes {
  static const String initialRoute = '/';
  static const String dashboardRoute = '/dashboard';
  static const String depositRoute = '/deposit';
  static const String withdrawRoute = '/withdraw';
  static const String transferRoute = '/transfer';
  static const String transactionsRoute = '/transactions';
}