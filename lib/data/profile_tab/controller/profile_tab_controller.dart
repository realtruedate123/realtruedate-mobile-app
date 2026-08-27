import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/profile_tab/model/profile_model.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:real_true_date/routes/routes.dart';

class ProfileTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  var userProfile = DataModel().obs; // ✅ initialize safely

  final prefHelper = SharedPrefHelper();

  final List<ProfileSection> profileSections = [
    ProfileSection(
      items: [
        ProfileMenuItem(
          title: "My Profile",
          icon: AppIcons.getMyProfileIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "Saved Profiles",
          icon: AppIcons.getSaveProfileIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "Change Password",
          icon: AppIcons.getChangePasswordIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "Update Video & Photos",
          icon: AppIcons.getProfileVideoIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "Subscriptions",
          icon: AppIcons.getSubscriptionsIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "Payment History",
          icon: AppIcons.getPaymentIcon(Get.context!, size: 38),
          onTap: () {},
        ),
      ],
    ),
    ProfileSection(
      title: "More",
      items: [
        ProfileMenuItem(
          title: "Help & Support",
          icon: AppIcons.getHelpSupportIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "Feedback",
          icon: AppIcons.getFeedbackIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "About Us",
          icon: AppIcons.getAboutUsIcon(Get.context!, size: 38),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: "Log Out",
          icon: AppIcons.getUserLogoutIcon(Get.context!, size: 38),
          onTap: () {},
        ),
      ],
    ),
  ].obs;


  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Get saved local user data
  void getUserData() async {
    try {
      // Fetch from API or storage
      final data = await prefHelper.getPersonList();
      userProfile.value = data ?? DataModel();

    } finally {
      isLoading.value = false;
    }
  }

  /// Removed local data saved
  void removePreference() {
    Purchases.logOut();
    prefHelper.clearAllPreferences();
    // Get.offNamed(Routes.authPage);
    // Get.offAll(() => AuthController());
    Get.deleteAll();
    Get.offAllNamed(Routes.authPage);
  }

  //TODO: Logout API Call
  Future<void> logoutApiCall() async {
    final token = await prefHelper.getAuthToken;

    final params = {
      "refresh_token": token,
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    final response = await BaseApiService().postRawData<CommonModel>(
      endpoint: Endpoints.logout,
      fields: params,
      headers: header,
      fromJson: (json) => CommonModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      print("Response data: ${response.data?.message}");
      removePreference();
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          logoutApiCall();
        }
      } else {
        print(response.message ?? 'Logout - Something want wrong');
      }
    }
  }

  Future<void> deleteAccountApiCall() async {
    final token = await prefHelper.getAuthToken;

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    final response = await BaseApiService().deleteRawData<DeleteUserModel>(
      endpoint: Endpoints.deleteAccount,
      headers: header,
      fromJson: (json) => DeleteUserModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      print("Response data: ${response.data?.message}");
      if(response.data?.data?.deleted ==  true){
        removePreference();
      }
      else{
        Get.snackbar('Oops!', response.message ?? 'Your account could not be deleted at this time. Please try again later.');
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          deleteAccountApiCall();
        }
      } else {
        print(response.message ?? 'Logout - Something want wrong');
      }
    }
  }
}
