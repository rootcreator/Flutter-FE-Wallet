import 'package:flutter/material.dart';
import 'package:wallet/screens/cards.dart';
import 'package:wallet/screens/investment.dart';
import 'package:wallet/screens/settings.dart';
import 'package:wallet/screens/wallet.dart';
import 'package:wallet/services/api_service.dart';
import 'package:wallet/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.loadToken(); // Load token before app starts
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while checking login status
          } else {
            if (snapshot.data == true) {
              return const WalletApp(); // User is logged in, show main app
            } else {
              return const LoginScreen(); // User is not logged in, show login screen
            }
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    String? token = await ApiService.getToken();
    return token != null && token.isNotEmpty;
  }
}

class WalletApp extends StatefulWidget {
  const WalletApp({super.key});

  @override
  _WalletAppState createState() => _WalletAppState();
}

class _WalletAppState extends State<WalletApp> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    WalletPage(),
    InvestmentPage(),
    CardPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        title: const Text('Wallet App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ApiService.clearToken(); // Clear the stored token
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Investment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}