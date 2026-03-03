import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/preference_key.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/home_tab/model/feed_response.dart';
import 'package:real_true_date/data/home_tab/model/swipe_card_model.dart';
import 'package:real_true_date/data/root_tab_controller.dart';

class HomeTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final sharedPref = SharedPrefHelper();

  /// CONTROLLERS

  /// Button enable state
  final isLoginEnabled = false.obs;

  late final AppinioSwiperController swiperController;

  final feedListModel = <Candidate>[].obs;
  var userID = '';

  @override
  void onInit() {
    super.onInit();
    Get.find<RootTabController>().switchTo(0); // always reset to home
    isLoading.value = true;
    getUserData();
    getFeedListApiCall();
    swiperController = AppinioSwiperController();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  /// Get saved local user data
  void getUserData() async {
    try {
      // Fetch from API or storage
      userID = await sharedPref.getUserId;
      print('home userid $userID');
    } finally {
      isLoading.value = false;
    }
  }

  //TODO: Get feeds API Call

  Future<void> getFeedListApiCall() async {
    isLoading.value = true;
    final authToken = await sharedPref.getAuthToken;
    errorMessage.value = '';
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<FeedResponse>(
      endpoint: Endpoints.getFeed,
      headers: header,
      showLoader: false,
      fromJson: (json) => FeedResponse.fromJson(json),
    );

    isLoading.value = false;

    if (response.isSuccess &&
        response.statusCode == 200 &&
        response.data?.success == true) {
      feedListModel.value =
          response.data?.data.candidates.reversed.toList() ?? [];
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getFeedListApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
    update();
  }

  //TODO: Swipe card API Call
  Future<void> swipeCardApiCall(String direction) async {
    final authToken = await sharedPref.getAuthToken;

    final params = {
      "user_id": userID,
      "direction": direction
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    print('token $authToken');
    print('params $params');

    final response = await BaseApiService().postRawData<SwipeCardModel>(
      endpoint: Endpoints.swipeCard,
      fields: params,
      headers: header,
      fromJson: (json) => SwipeCardModel.fromJson(json),
      showLoader: false
    );

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      print('swipe card ${response.data?.message}');

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      // errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }

}
