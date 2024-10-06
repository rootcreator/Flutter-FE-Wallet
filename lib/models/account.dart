class Account {
  final String username; // Assuming you want to include the username
  final double balance;

  Account({required this.username, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['user'], // Adjust based on your API response
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}