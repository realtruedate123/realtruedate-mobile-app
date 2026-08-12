import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/preference_key.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/home_tab/model/create_chat_model.dart';
import 'package:real_true_date/data/home_tab/model/feed_response.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/home_tab/model/swipe_card_model.dart';
import 'package:real_true_date/data/home_tab/widget/matches_popup.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/routes/routes.dart';

class HomeTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  late var userProfileUrl = '';

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

      final data = await sharedPref.getPersonList();
      final userProfile = data ?? DataModel();

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
    print('swipe card matched ${response.data?.data.matched}');
    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      print('swipe card ${response.data?.message}');
      print('swipe card matched ${response.data?.data.matched}');

      if(response.data?.data.matched == true){
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
              createMessageApiCall(response.data?.data.matchId ?? item.userId);
            },
          ),
        );
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          swipeCardApiCall(direction, item);
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something went wrong');
      }
      // errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
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
          createMessageApiCall(matchUserID);
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
      // errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }
}
