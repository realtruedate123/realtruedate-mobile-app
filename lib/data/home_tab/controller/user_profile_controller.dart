import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/home_tab/model/feed_response.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/home_tab/model/swipe_card_model.dart';
import 'package:real_true_date/data/home_tab/widget/matches_popup.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/helper/common_model.dart';

class UserProfileController extends GetxController {

  /// UI State
  final isFavorite = false.obs;
  final isLoading = false.obs;

  final sharedPref = SharedPrefHelper();

  final Candidate matchData = Get.arguments;
  final profileData = ProfileData().obs;
  late var userProfileUrl = '';

  @override
  void onInit() {
    super.onInit();
    getUserData();
    getProfileApiCall();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toggleFavorite() {
    // isFavorite.toggle();
    favoritesMatchProfileApiCall();
  }

  /// Get saved local user data
  void getUserData() async {
    try {
      final data = await sharedPref.getPersonList();
      final userProfile = data ?? DataModel();
      userProfileUrl = userProfile.user?.profileImage ?? '';
    } finally {
      isLoading.value = false;
    }
  }

  //TODO: Get profile API Call

  Future<void> getProfileApiCall() async {
    isLoading.value = true;
    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<ProfileMatchDetailsModel>(
      endpoint: '${Endpoints.matchProfileUser}/${matchData.userId}/profile',
      headers: header,
      showLoader: false,
      fromJson: (json) => ProfileMatchDetailsModel.fromJson(json),
    );

    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      profileData.value = response.data?.data ?? ProfileData();
      isFavorite.value = response.data?.data?.isFavorite ?? false;
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getProfileApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
    update();
  }

  Future<void> swipeCardApiCall(String direction) async {
    final authToken = await sharedPref.getAuthToken;

    final params = {
      "user_id": profileData.value.id ?? '',
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
      if(response.data?.data.matched == true){
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => MatchPopup(
              userId: matchData.userId,
              name: matchData.firstName,
              age: matchData.age,
              city: matchData.city ?? '',
              state: matchData.state ?? '',
              photoUrl: matchData.photoUrl ?? '',
              isVerified: matchData.isVerified,
            userProfileUrl: userProfileUrl,
            onMessage: () {
              print('message');
            }
          ),
        );
      }

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      // errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }

  Future<void> createMessageApiCall(String direction) async {
    final authToken = await sharedPref.getAuthToken;

    final params = {
      "match_id": matchData.userId,
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    print('token $authToken');
    print('params $params');

    final response = await BaseApiService().postRawData<CommonModel>(
        endpoint: Endpoints.conversationsGetOrCreate,
        fields: params,
        headers: header,
        fromJson: (json) => CommonModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      print('create message ${response.data?.message}');
      // if(response.data?.data.matched == true){
      //
      // }

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      // errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }

  Future<void> favoritesMatchProfileApiCall() async {
    final token = await sharedPref.getAuthToken;

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    final response = await BaseApiService().postRawData<ProfileFavoritesModel>(
      endpoint: '${Endpoints.favoritesMatchProfile}/${matchData.userId}/toggle',
      headers: header,
      fromJson: (json) => ProfileFavoritesModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {

      print("Response data: ${response.data?.message}");
      isFavorite.value = response.data?.data?.isFavorite ?? false;
      Get.snackbar('Success', response.message ?? 'Profile saved',
          colorText: Colors.white,
          backgroundColor: Colors.green
      );
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      Get.snackbar('Failed', response.message ?? 'Profile not saved',
        colorText: Colors.white,
        backgroundColor: Colors.red
      );
    }
  }
}
