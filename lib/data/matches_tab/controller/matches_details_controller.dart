import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/home_tab/model/create_chat_model.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/matches_tab/model/matches_list_model.dart';
import 'package:real_true_date/helper/address_service_wrapper.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:real_true_date/routes/routes.dart';

class MatchesDetailsController extends GetxController {

  /// UI State
  final isFavorite = false.obs;
  final isLoading = false.obs;

  // final MatchList matchData = Get.arguments['data'];
  final MatchList? matchData = Get.arguments != null ? Get.arguments['data'] : null;
  final sharedPref = SharedPrefHelper();
  final profileData = ProfileData().obs;
  late var matchDataId = '';
  late var cityName = ''.obs;
  late var stateName = ''.obs;
  final locationService = AddressServiceWrapper();

  @override
  void onInit() {
    super.onInit();

    if (matchData == null) {
      // No data found
      matchDataId = Get.arguments['id'];
    }
    else{
      matchDataId = matchData?.user?.id ?? '';
    }

    getProfileApiCall();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toggleFavorite() {
    isFavorite.toggle();
  }

  //TODO: Block user API call
  Future<void> blockUserApiCall() async {
    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final Map<String, String> params = {
      "user_id": matchDataId,
    };
    print('params $params');

    final response = await BaseApiService().postRawData<CommonModel>(
      endpoint: Endpoints.blockUser,
      fields: params,
      headers: header,
      fromJson: (json) => CommonModel.fromJson(json),
    );
    if (response.isSuccess && response.statusCode == 200) {
      Get.snackbar('Success', response.message ?? 'User blocked successfully');
      Get.back(result: true);
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      Get.snackbar('Failed', response.message ?? 'Block failed');
    }
  }

  Future<void> getProfileApiCall() async {
    isLoading.value = true;
    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<ProfileMatchDetailsModel>(
      endpoint: '${Endpoints.matchProfileUser}/$matchDataId/profile',
      headers: header,
      showLoader: false,
      fromJson: (json) => ProfileMatchDetailsModel.fromJson(json),
    );

    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      profileData.value = response.data?.data ?? ProfileData();

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
