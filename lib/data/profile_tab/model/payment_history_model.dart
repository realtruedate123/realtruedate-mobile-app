class PaymentHistoryModel {
  final String title;
  final String timeAgo;
  final double amount;
  final bool isDebit;

  const PaymentHistoryModel({
    required this.title,
    required this.timeAgo,
    required this.amount,
    this.isDebit = true,
  });
}