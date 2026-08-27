import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/services/subscription_service.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:real_true_date/data/home_tab/model/create_chat_model.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/home_tab/model/swipe_card_model.dart';
import 'package:real_true_date/data/home_tab/widget/matches_popup.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/notifications/model/notification_list_model.dart';
import 'package:real_true_date/helper/address_service_wrapper.dart';
import 'package:real_true_date/routes/routes.dart';

class UserRequestController extends GetxController {

  /// UI State
  final isFavorite = false.obs;
  final isLoading = false.obs;

  final sharedPref = SharedPrefHelper();

  late final NotificationObject matchData;
  final profileData = ProfileData().obs;
  late var userProfileUrl = '';
  late var cityName = ''.obs;
  late var stateName = ''.obs;
  final locationService = AddressServiceWrapper();
  RxBool typeStatus = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments ?? {};

    final data = arguments['data'];
    final id = arguments['id'];
    final type = arguments['type'];

    if (data != null) {
      // Open using data
      matchData = data;
    } else if (id != null) {
      // Open using id
    } else if (type != null) {
      // Open using id
      typeStatus = type;
    } else {
      // Nothing was passed
    }

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
      // isLoading.value = false;
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
      endpoint: '${Endpoints.matchProfileUser}/${matchData.senderId}/profile',
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
      if(response.data?.data?.matched == true){
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => MatchPopup(
              userId: matchData.senderId ?? '',
              name: profileData.value.firstName ?? '',
              age: profileData.value.age ?? 0,
              city: profileData.value.city ?? '',
              state: profileData.value.state ?? '',
              photoUrl: matchData.senderPhoto ?? '',
              isVerified: profileData.value.isVerified ?? false,
            userProfileUrl: userProfileUrl,
            onMessage: () {
              print('message');
              createMessageApiCall();
            }
          ),
        );
      }

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          swipeCardApiCall(direction);
        }
      } else if(response.data?.success == false){
        if(response.data?.data?.subscriptionRequired == true){
          SubscriptionService().checkSubscription(
            isExpired: AppState.instance.isExpired,
            isPremium: AppState.instance.isPremium,
            freeSwipesUsed: AppState.instance.freeSwipesUsed,
            freeSwipesLimit: AppState.instance.freeSwipesLimit,
          );
        }
        else{
          Get.snackbar('Failed', response.message ?? 'Something went wrong');
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'failed');
      }
      // errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }

  Future<void> createMessageApiCall() async {
    final authToken = await sharedPref.getAuthToken;

    final params = {
      "match_id": matchData.senderId,
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    print('token $authToken');
    print('params $params');

    final response = await BaseApiService().postRawData<CreateChatModel>(
        endpoint: Endpoints.conversationsGetOrCreate,
        fields: params,
        headers: header,
        fromJson: (json) => CreateChatModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      print('create message ${response.data?.data?.conversationId}');

      Get.toNamed(Routes.chatView, arguments: {
        'conversation_id': response.data?.data?.conversationId
      });

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          createMessageApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'failed');
      }
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
      endpoint: '${Endpoints.favoritesMatchProfile}/${matchData.senderId}/toggle',
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
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          favoritesMatchProfileApiCall();
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
