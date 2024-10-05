class Deposit {
  final double amount;
  final String transactionId; // You can link this to the Transaction model

  Deposit({
    required this.amount,
    required this.transactionId,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      amount: (json['amount'] ?? 0).toDouble(),
      transactionId: json['transaction_id'],
    );
  }
}