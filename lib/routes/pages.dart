import 'package:get/get.dart';
import 'package:real_true_date/data/confirmation_screens/controller/LivePhotoInformationController.dart';
import 'package:real_true_date/data/confirmation_screens/view/live_photo_information_view.dart';
import 'package:real_true_date/data/forgot_password/forgot_password.dart';
import 'package:real_true_date/data/forgot_password/forgot_password_controller.dart';
import 'package:real_true_date/data/home_tab/controller/user_profile_controller.dart';
import 'package:real_true_date/data/home_tab/view/user_profile_view.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:real_true_date/data/login_signup/view/auth_screen.dart';
import 'package:real_true_date/data/matches_tab/controller/matches_details_controller.dart';
import 'package:real_true_date/data/matches_tab/view/matches_details_view.dart';
import 'package:real_true_date/data/message_tab/controller/chat_controller.dart';
import 'package:real_true_date/data/message_tab/controller/chat_profile_controller.dart';
import 'package:real_true_date/data/message_tab/view/chat_profile_view.dart';
import 'package:real_true_date/data/message_tab/view/chat_view.dart';
import 'package:real_true_date/data/notifications/controller/notification_controller.dart';
import 'package:real_true_date/data/notifications/controller/user_request_controller.dart';
import 'package:real_true_date/data/notifications/view/notifications_view.dart';
import 'package:real_true_date/data/notifications/view/user_request_view.dart';
import 'package:real_true_date/data/otp_reset_password/controller/otp_controller.dart';
import 'package:real_true_date/data/otp_reset_password/controller/reset_password_controller.dart';
import 'package:real_true_date/data/otp_reset_password/view/otp_view.dart';
import 'package:real_true_date/data/otp_reset_password/view/password_reset_success.dart';
import 'package:real_true_date/data/otp_reset_password/view/reset_password.dart';
import 'package:real_true_date/data/profile_tab/controller/change_password_controller.dart';
import 'package:real_true_date/data/profile_tab/controller/edit_profile_controller.dart';
import 'package:real_true_date/data/profile_tab/controller/help_support_controller.dart';
import 'package:real_true_date/data/profile_tab/controller/save_profile_details_controller.dart';
import 'package:real_true_date/data/profile_tab/controller/saved_profile_controller.dart';
import 'package:real_true_date/data/profile_tab/view/Change_password_view.dart';
import 'package:real_true_date/data/profile_tab/view/edit_profile_view.dart';
import 'package:real_true_date/data/profile_tab/view/help_support_view.dart';
import 'package:real_true_date/data/profile_tab/view/save_profile_details_view.dart';
import 'package:real_true_date/data/profile_tab/view/saved_profile_view.dart';
import 'package:real_true_date/data/select_dream_partner/controller/SelectDreamPartnerController.dart';
import 'package:real_true_date/data/select_dream_partner/view/select_dream_partner_view.dart';
import 'package:real_true_date/data/splash_on_boarding%20/on_boarding.dart';
import 'package:real_true_date/data/splash_on_boarding%20/splash_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/upload_picture_controller.dart';
import 'package:real_true_date/data/upload_picture_and_video/upload_video_controller.dart';
import 'package:real_true_date/data/upload_picture_and_video/view/profile_under_review_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/view/upload_picture_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/view/upload_video_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/widget/camera_controller.dart';
import 'package:real_true_date/data/upload_picture_and_video/widget/camera_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/widget/custom_camera.dart';
import 'package:real_true_date/data/upload_picture_and_video/widget/custom_camera_controller.dart';
import 'package:real_true_date/routes/splash_binding.dart';
import 'routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
      binding:SplashBinding(),
    ),
    GetPage(
      name: Routes.onBoarding,
      page: () => OnBoardingPage(),
    ),
    GetPage(
      name: Routes.authPage,
      page: () => AuthScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => ForgotPassword(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: Routes.otpScreen,
      page: () => OtpView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OtpController());
      }),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => ResetPassword(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ResetPasswordController());
      }),
    ),
    GetPage(
      name: Routes.passwordResetSuccess,
      page: () => PasswordResetSuccess(),
    ),
    GetPage(
      name: Routes.uploadPhotoPage,
      page: () => UploadPictureScreen(),
      binding: BindingsBuilder((){
      Get.lazyPut(() => UploadPhotoController());
      })
    ),
    GetPage(
        name: Routes.uploadVideoPage,
        page: () => UploadVideoScreen(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => UploadVideoController());
        })
    ),
    GetPage(
      name: Routes.profileUnderReviewScreen,
      page: () => ProfileUnderReviewScreen(),
    ),
    GetPage(
        name: Routes.userProfileView,
        page: () => UserProfileDetailsScreen(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => UserProfileController());
        })
    ),
    GetPage(
        name: Routes.matchesDetailsView,
        page: () => MatchesDetailsView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => MatchesDetailsController());
        })
    ),
    GetPage(
        name: Routes.notificationView,
        page: () => NotificationsScreen(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => NotificationController());
        })
    ),
    GetPage(
        name: Routes.chatView,
        page: () => ChatView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => ChatController());
        })
    ),
    GetPage(
        name: Routes.editProfileView,
        page: () => EditProfileView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => EditProfileController());
        })
    ),
    GetPage(
        name: Routes.cameraView,
        page: () => CameraScreen(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => CameraViewController());
        })
    ),
    GetPage(
        name: Routes.selectDreamPartnerView,
        page: () => SelectDreamPartnerView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => SelectDreamPartnerController());
        })
    ),
    GetPage(
        name: Routes.customCamera,
        page: () => CustomCamera(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => CustomCameraController());
        })
    ),
    GetPage(
        name: Routes.confirmationInfo,
        page: () => LivePhotoInformationView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => LivePhotoInformationController());
        })
    ),
    GetPage(
        name: Routes.changePassword,
        page: () => ChangePasswordView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => ChangePasswordController());
        })
    ),
    GetPage(
        name: Routes.savedProfileView,
        page: () => SavedProfileView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => SavedProfileController());
        })
    ),
    GetPage(
        name: Routes.savedProfileDetailsView,
        page: () => SaveProfileDetailsView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => SaveProfileDetailsController());
        })
    ),
    GetPage(
        name: Routes.chatProfileDetailsView,
        page: () => ChatProfileDetailsScreen(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => ChatProfileController());
        })
    ),
    GetPage(
        name: Routes.userRequestView,
        page: () => UserRequestView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => UserRequestController());
        })
    ),
    GetPage(
        name: Routes.helpSupportView,
        page: () => HelpSupportView(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => HelpSupportController());
        })
    ),
    // GetPage(
    //   name: Routes.account,
    //   page: () => ProfilePage(),
    // ),
    // GetPage(
    //   name: Routes.wallet,
    //   page: () => WalletPage(),
    // ),
    // GetPage(
    //   name: Routes.certification,
    //   page: () => CertificationPage(),
    // ),
    // GetPage(
    //   name: Routes.earning,
    //   page: () => EarningPage(),
    // ),
    // GetPage(
    //   name: Routes.rating,
    //   page: () => RatingsPage(),
    // ),
    // GetPage(
    //   name: Routes.notification,
    //   page: () => NotificationPage(),
    // ),
    // GetPage(
    //   name: Routes.history,
    //   page: () => BookingHistoryPage(),
    // ),
    // GetPage(
    //   name: Routes.withdraw,
    //   page: () => WithdrawPage(),
    // ),
    // GetPage(
    //   name: Routes.termCondition,
    //   page: () => TermConditionPage(),
    // ),
    // GetPage(
    //   name: Routes.sos,
    //   page: () => SosPage(),
    // ),
    // GetPage(
    //   name: Routes.serviceCompleted,
    //   page: () => ServiceCompletedPage(),
    // ),
    // GetPage(
    //   name: Routes.appointmentAccept,
    //   page: () => AppointmentAcceptPage(),
    // ),
    // GetPage(
    //   name: Routes.selectCategory,
    //   page: () => SelectCategoryPage(),
    // ),
    // GetPage(
    //   name: Routes.upcomingBooking,
    //   page: () => UpComingBookingPage(),
    // ),
    // GetPage(
    //   name: Routes.appointment,
    //   page: () => AppointmentRequestPage(),
    // ),
    // GetPage(
    //   name: Routes.uploadCertificate,
    //   page: () => UploadCertificatePage(),
    // ),
    // GetPage(
    //   name: Routes.editProfile,
    //   page: () => EditProfilePage(),
    // ),
    // GetPage(
    //   name: Routes.allTransaction,
    //   page: () => AllTransactionsPage(),
    // ),
  ];
}