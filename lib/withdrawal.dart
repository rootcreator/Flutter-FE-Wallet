class Withdrawal {
  final double amount;
  final String transactionId; // You can link this to the Transaction model

  Withdrawal({
    required this.amount,
    required this.transactionId,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      amount: (json['amount'] ?? 0).toDouble(),
      transactionId: json['transaction_id'],
    );
  }
}