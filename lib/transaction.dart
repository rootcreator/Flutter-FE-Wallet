class Transaction {
  final String id; // UUID of the transaction
  final String user; // User associated with the transaction
  final String transactionType; // e.g., deposit, withdrawal, transfer
  final double amount; // Amount of the transaction
  final String status; // e.g., pending, completed, failed
  final DateTime createdAt; // Timestamp when the transaction was created

  Transaction({
    required this.id,
    required this.user,
    required this.transactionType,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'], // Ensure this matches your API response structure
      user: json['user'],
      transactionType: json['transaction_type'],
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']), // Adjust if needed
    );
  }
}