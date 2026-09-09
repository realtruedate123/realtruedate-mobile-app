import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/message_tab/model/chat_model.dart';
import 'package:real_true_date/data/message_tab/model/message_model.dart';
import 'package:real_true_date/helper/address_service_wrapper.dart';

class ChatProfileController extends GetxController {

  /// UI State
  final isFavorite = false.obs;
  final isLoading = false.obs;

  final sharedPref = SharedPrefHelper();

  final toUserId = Get.arguments['id'] ?? '';
  final profileData = ProfileData().obs;
  final recipientData = RecipientMessage().obs;
  late var userProfileUrl = '';
  late var cityName = ''.obs;
  late var stateName = ''.obs;
  final locationService = AddressServiceWrapper();

  @override
  void onInit() {
    super.onInit();

    recipientData.value = Get.arguments['data'] ?? Recipient();

    getUserData();
    getProfileApiCall();
  }

  void toggleFavorite() {
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
      endpoint: '${Endpoints.matchProfileUser}/$toUserId/profile',
      headers: header,
      showLoader: false,
      fromJson: (json) => ProfileMatchDetailsModel.fromJson(json),
    );

    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      profileData.value = response.data?.data ?? ProfileData();
      isFavorite.value = response.data?.data?.isFavorite ?? false;

      final address = await locationService.getAddressFromLatLng(
        profileData.value.latitude ?? 0,
        profileData.value.longitude ?? 0,
      );
      cityName.value = address?.cityName ?? '';
      stateName.value = address?.stateName ?? '';

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

  /*Future<void> swipeCardApiCall(String direction) async {
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
      if(response.data?.data?.matched == true){

      }

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getProfileApiCall();
        }
      } else {
      }
      // errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }*/

  Future<void> favoritesMatchProfileApiCall() async {
    final token = await sharedPref.getAuthToken;

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    final response = await BaseApiService().postRawData<ProfileFavoritesModel>(
      endpoint: '${Endpoints.favoritesMatchProfile}/$toUserId/toggle',
      headers: header,
      fromJson: (json) => ProfileFavoritesModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
      isFavorite.value = response.data?.data?.isFavorite ?? false;
      Get.snackbar('Success', response.message ?? 'Profile saved',
          colorText: Colors.white,
          backgroundColor: Colors.green
      );
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getProfileApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Profile not saved',
            colorText: Colors.white,
            backgroundColor: Colors.red
        );
      }
    }
  }
}
