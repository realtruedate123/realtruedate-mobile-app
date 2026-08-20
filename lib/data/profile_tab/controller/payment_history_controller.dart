import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/data/profile_tab/model/payment_history_model.dart';

class PaymentHistoryController extends GetxController {

  // --- Loading State ---
  var isLoading = false.obs;

  final prefHelper = SharedPrefHelper();

  // Dynamic data
  final List<PaymentHistoryModel> transactions = [
    PaymentHistoryModel(
      title: 'Monthly Subscription',
      timeAgo: '7 hours ago',
      amount: 10.00,
      isDebit: true,
    ),
    PaymentHistoryModel(
      title: 'Monthly Subscription',
      timeAgo: '7 hours ago',
      amount: 10.00,
      isDebit: true,
    ),
  ];

  String formatAmount(double amount) {
    final sign = amount < 0 ? '-\$' : '+\$';
    return '$sign${amount.abs().toStringAsFixed(2)}';
  }

  @override
  void onInit() {
    super.onInit();

  }

  void getPaymentHistory(){

  }

  @override
  void onClose() {
    super.onClose();
  }
}