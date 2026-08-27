import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/preference_key.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/services/subscription_service.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:real_true_date/data/home_tab/model/create_chat_model.dart';
import 'package:real_true_date/data/home_tab/model/feed_response.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/home_tab/model/swipe_card_model.dart';
import 'package:real_true_date/data/home_tab/widget/matches_popup.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/profile_tab/model/subscription_plan_model.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/helper/address_service_wrapper.dart';
import 'package:real_true_date/helper/custom_dialog/upgrade_plan_dialog_view.dart';
import 'package:real_true_date/routes/routes.dart';

class HomeTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  late var userProfileUrl = '';

  final sharedPref = SharedPrefHelper();
  final locationService = AddressServiceWrapper();

  /// CONTROLLERS

  /// Button enable state
  final isLoginEnabled = false.obs;

  late final AppinioSwiperController swiperController;

  final feedListModel = <Candidate>[].obs;
  var userID = '';
  late var userProfile = DataModel();

  @override
  void onInit() {
    super.onInit();
    Get.find<RootTabController>().switchTo(0); // always reset to home
    isLoading.value = true;
    getApiData();
    getFeedListApiCall();
    swiperController = AppinioSwiperController();
  }

  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  void getApiData(){
    getUserData();
    getSubscriptionStatusApiCall();
  }

  /// Get saved local user data
  void getUserData() async {
    try {
      // Fetch from API or storage
      userID = await sharedPref.getUserId;
      AppState.instance.loginUserID = userID;

      final data = await sharedPref.getPersonList();
      userProfile = data ?? DataModel();

      userProfileUrl = userProfile.user?.profileImage ?? '';
      if(userProfile.user?.profileImage?.isEmpty ?? false){
        userProfileUrl = userProfile.photos?.first.photoUrl ?? '';
      }

      print('home userid $userID');
      print('home userProfileUrl $userProfileUrl');
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

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      feedListModel.value = response.data?.data.candidates.reversed.toList() ?? [];
      print('feedListModel ${feedListModel.length}');
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        print('response.tokenExpired ${response.tokenExpired}');
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

  Future<String> getAddress(double latitude, double longitude) {
    return getLocation(latitude, longitude);
  }

  Future<String> getLocation(double latitude, double longitude) async {
    final address = await locationService.getAddressFromLatLng(
      latitude,
      longitude,
    );

    return '${address?.cityName}, ${address?.stateName}';
  }

  //TODO: Swipe card API Call
  Future<void> swipeCardApiCall(String direction, Candidate item) async {
    final authToken = await sharedPref.getAuthToken;

    final params = {
      "user_id": item.userId,
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
    print('swipe card matched ${response.data?.data?.matched}');

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      if(response.data?.data?.matched == true){
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => MatchPopup(
            userId: item.userId,
            name: item.firstName,
            age: item.age,
            city: item.city ?? '',
            state: item.state ?? '',
            photoUrl: item.photoUrl ?? '',
            isVerified: item.isVerified,
              userProfileUrl: userProfileUrl,
            onMessage: () {
              print('message');
              createMessageApiCall(response.data?.data?.matchId ?? item.userId);
            },
          ),
        );
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        print('response.tokenExpired ${response.tokenExpired}');
        final result = await BaseApiService().refreshToken();
        if (result.data?.success == true) {
          swipeCardApiCall(direction, item);
        } else if (result.data?.success == false && result.data?.tokenExpired == true){
          SharedPrefHelper().clearAllPreferences();
          Get.deleteAll();
          Get.offAllNamed(Routes.authPage);
        }
      } else if(response.data?.success == false){
          if(response.data?.data?.subscriptionRequired == true){
            final bool isBlocked = SubscriptionService().checkSubscription(
              isExpired: AppState.instance.isExpired,
              isPremium: AppState.instance.isPremium,
              freeSwipesUsed: AppState.instance.freeSwipesUsed,
              freeSwipesLimit: AppState.instance.freeSwipesLimit,
            );

            if (isBlocked) {
              await Future.delayed(const Duration(seconds: 3));
              getFeedListApiCall();
            }
          }
          else{
            Get.snackbar('Failed', response.message ?? 'Something went wrong');
          }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something went wrong');
      }
    }
  }

  Future<void> favoritesMatchProfileApiCall(String matchUserID) async {
    // createMessageApiCall('7facd8bc-a29b-4fc3-b5af-92d7d457553e');
    // return;

    final token = await sharedPref.getAuthToken;

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    final response = await BaseApiService().postRawData<ProfileFavoritesModel>(
      endpoint: '${Endpoints.favoritesMatchProfile}/$matchUserID/toggle',
      // endpoint: '',
      headers: header,
      fromJson: (json) => ProfileFavoritesModel.fromJson(json),
    );
    print('fav response ${response.statusCode}');
    if (response.isSuccess && response.statusCode == 200) {

      print("Response data: ${response.data?.message}");
      // isFavorite.value = response.data?.data?.isFavorite ?? false;
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
          favoritesMatchProfileApiCall(matchUserID);
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Profile not saved',
            colorText: Colors.white,
            backgroundColor: Colors.red
        );
      }
    }
  }

  Future<void> createMessageApiCall(String matchUserID) async {
    final authToken = await sharedPref.getAuthToken;
    //7facd8bc-a29b-4fc3-b5af-92d7d457553e
    final params = {
      "match_id": matchUserID,
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    print('url ${Endpoints.conversationsGetOrCreate}');
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
      print('Failed ${response.message}');
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          createMessageApiCall(matchUserID);
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something went wrong');
      }
    }
  }

  /// Get subscription status API call
  Future<void> getSubscriptionStatusApiCall() async {
    final token = await sharedPref.getAuthToken;

    final response = await BaseApiService().getMethod<SubscriptionStatusModel>(
      endpoint: Endpoints.subscriptionStatus,
      headers: {
        'Authorization': 'Bearer $token'
      },
      showLoader: false,
      fromJson: (json) => SubscriptionStatusModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
        AppState.instance.isPremium = response.data?.data?.isPremium;
        AppState.instance.isExpired = response.data?.data?.isExpired;
        AppState.instance.freeSwipesUsed = response.data?.data?.freeSwipesUsed;
        AppState.instance.freeSwipesLimit = response.data?.data?.freeSwipesLimit;
        print('${AppState.instance.isPremium} isPremium ${response.data?.data?.isPremium}');

        final bool isBlocked = SubscriptionService().checkSubscription(
          isExpired: response.data?.data?.isExpired,
          isPremium: response.data?.data?.isPremium,
          freeSwipesUsed: response.data?.data?.freeSwipesUsed,
          freeSwipesLimit: response.data?.data?.freeSwipesLimit,
        );
        print('isBlocked $isBlocked');

      /*if(response.data?.data?.isExpired == true){
          subscriptionAlert(
              StringMessage.subscriptionExpiredTitle,
            StringMessage.subscriptionExpiredMessage,
          );
        } else if(response.data?.data?.isPremium == false &&
            (response.data?.data?.freeSwipesUsed ?? 0) >= (response.data?.data?.freeSwipesLimit ?? 0)){
          subscriptionAlert(
              StringMessage.freeSwapeTitle,
            StringMessage.freeSwapeMessage,
          );
        } else{
          print('no message');
        }*/

        /*if(response.data?.data?.isPremium == false &&
            (response.data?.data?.freeSwipesUsed ?? 0) >= (response.data?.data?.freeSwipesLimit ?? 0)){

          subscriptionAlert(
              'You’ve Used All 3 Free Swaps',
              'You’ve reached your free swap limit. Upgrade to a monthly plan to enjoy unlimited swaps and full access.'
          );
        } else if (response.data?.data?.isExpired == true){
          subscriptionAlert(
              'Your Subscription Has Expired',
              'Your subscription has expired. Renew your monthly plan to continue enjoying unlimited swaps and full access.'
          );
        }*/

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getSubscriptionStatusApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something went wrong');
      }
    }
  }

  /*void subscriptionAlert(String title, String message){
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => UpgradePlanDialogView(
        title: title,
        message: message,
        confirmText: 'Upgrade Plan',
        onConfirm: () {
          print('Upgrade Plan');
          Get.back();
          Get.toNamed(Routes.subscriptionView);
        },
      ),
    );
  }*/
}
