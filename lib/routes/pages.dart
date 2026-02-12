import 'package:get/get.dart';
import 'package:real_true_date/data/forgot_password/forgot_password.dart';
import 'package:real_true_date/data/forgot_password/forgot_password_controller.dart';
import 'package:real_true_date/data/home_tab/controller/user_profile_controller.dart';
import 'package:real_true_date/data/home_tab/view/user_profile_view.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:real_true_date/data/login_signup/view/auth_screen.dart';
import 'package:real_true_date/data/otp_reset_password/controller/otp_controller.dart';
import 'package:real_true_date/data/otp_reset_password/controller/reset_password_controller.dart';
import 'package:real_true_date/data/otp_reset_password/view/otp_view.dart';
import 'package:real_true_date/data/otp_reset_password/view/password_reset_success.dart';
import 'package:real_true_date/data/otp_reset_password/view/reset_password.dart';
import 'package:real_true_date/data/splash_on_boarding%20/on_boarding.dart';
import 'package:real_true_date/data/splash_on_boarding%20/splash_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/upload_picture_controller.dart';
import 'package:real_true_date/data/upload_picture_and_video/upload_video_controller.dart';
import 'package:real_true_date/data/upload_picture_and_video/view/profile_under_review_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/view/upload_picture_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/view/upload_video_screen.dart';
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