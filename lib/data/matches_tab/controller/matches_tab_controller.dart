import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/matches_tab/model/matches_list_model.dart';

class MatchesTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final sharedPref = SharedPrefHelper();

  /// CONTROLLERS

  /// Button enable state

  var matchesList = <MatchList>[].obs;

  @override
  void onInit() {
    super.onInit();

    getMatchesListApiCall();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //TODO: Get Matches List API Call
  Future<void> getMatchesListApiCall() async {

    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<MatchesListModel>(
      endpoint: Endpoints.getMatchesList,
      headers: header,
      fromJson: (json) => MatchesListModel.fromJson(json),
      showLoader: false
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      matchesList.value = response.data?.data?.matches ?? [];
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessage.value = response.message ?? 'Something went wrong';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
    update();
  }
}