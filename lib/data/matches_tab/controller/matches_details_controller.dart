import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/home_tab/model/profile_match_details_model.dart';
import 'package:real_true_date/data/matches_tab/model/matches_list_model.dart';
import 'package:real_true_date/helper/common_model.dart';

class MatchesDetailsController extends GetxController {

  /// UI State
  final isFavorite = false.obs;
  final isLoading = false.obs;

  // final MatchList matchData = Get.arguments['data'];
  final MatchList? matchData = Get.arguments != null ? Get.arguments['data'] : null;
  final sharedPref = SharedPrefHelper();
  final profileData = ProfileData().obs;
  late var matchDataId = '';

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
}
