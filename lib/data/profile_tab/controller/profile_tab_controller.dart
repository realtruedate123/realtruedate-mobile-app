import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/profile_tab/model/profile_model.dart';
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
    prefHelper.clearAllPreferences();
    // Get.offNamed(Routes.authPage);
    // Get.offAll(() => AuthController());
    Get.deleteAll();
    Get.offAllNamed(Routes.authPage);
  }
}
