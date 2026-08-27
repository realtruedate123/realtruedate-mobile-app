import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/profile_tab/model/payment_history_model.dart';

class PaymentHistoryController extends GetxController {

  // --- Loading State ---
  var isLoading = false.obs;

  final prefHelper = SharedPrefHelper();

  // Dynamic data
  final RxList<HistoryData> transactions = <HistoryData>[].obs;

  String formatAmount(double amount) {
    final sign = amount < 0 ? '-\$' : '+\$';
    return '$sign${amount.abs().toStringAsFixed(2)}';
  }

  @override
  void onInit() {
    super.onInit();

    getPaymentHistoryApiCall();
  }

  Future<void> getPaymentHistoryApiCall() async {
    isLoading.value = true;

    final authToken = await prefHelper.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<PaymentHistoryModel>(
      endpoint: Endpoints.subscriptionHistory,
      headers: header,
      showLoader: false,
      fromJson: (json) => PaymentHistoryModel.fromJson(json),
    );

    print('Get me api $header');
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      transactions.value = response.data?.data?.history ?? [];
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getPaymentHistoryApiCall();
        }
      } else {
        // Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
  }
}