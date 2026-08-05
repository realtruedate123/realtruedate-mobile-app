import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/matches_tab/controller/matches_tab_controller.dart';
import 'package:real_true_date/data/profile_tab/model/saved_profile_model.dart';

class SavedProfileController extends GetxController{
  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Button enable state
  final isLoginEnabled = false.obs;

  final sharedPref = SharedPrefHelper();

  var matchesList = <FavoriteModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    getSaveProfileListApiCall();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //TODO: Get Save profile List API Call
  Future<void> getSaveProfileListApiCall() async {

    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<SavedProfileModel>(
      endpoint: Endpoints.favoritesMatchProfile,
      headers: header,
      fromJson: (json) => SavedProfileModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
      matchesList.value = response.data?.data?.favorites ?? [];
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      Get.snackbar('Failed', response.message ?? 'Something went wrong');
    }
    update();
  }
}