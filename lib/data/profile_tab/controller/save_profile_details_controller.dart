import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/profile_tab/model/saved_profile_model.dart';
import 'package:real_true_date/helper/address_service_wrapper.dart';

class SaveProfileDetailsController extends GetxController {

  /// UI State
  final isFavorite = false.obs;
  final isLoading = false.obs;

  final FavoriteModel matchData = Get.arguments;
  final sharedPref = SharedPrefHelper();
  final profileData = ProfileData().obs;

  late var cityName = ''.obs;
  late var stateName = ''.obs;
  final locationService = AddressServiceWrapper();

  @override
  void onInit() {
    super.onInit();

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

  //TODO: API call
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
        print(response.message ?? 'failed');
        // Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
    update();
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
