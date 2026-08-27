import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/login_signup/model/register_model.dart';
import 'package:real_true_date/data/otp_reset_password/model/verify_otp_model.dart';
import 'package:real_true_date/data/video_slide/video_slide.dart';
import 'package:real_true_date/routes/routes.dart';

class OtpController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final emailId = Get.arguments['email'];
  final apiOTP = Get.arguments['otp'];
  final gender = Get.arguments['gender'];

  /// OTP state
  final otpCode = ''.obs;
  final isOtpValid = false.obs;
  final sharedPref = SharedPrefHelper();

  /// Button enable state
  final isLoginEnabled = false.obs;
  final PinInputController otpController = PinInputController();
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onClose() {
    super.onClose();
  }

  void onOtpChanged(String code) {
    otpCode.value = code;
    isOtpValid.value = code.length == 4;
  }

  void verifyOtp() {
    print('OTP Verified: ${otpCode.value}');
    /*if(apiOTP != otpCode.value.toString()){
      errorMessage.value = 'Please enter a valid OTP.';
    } else {
      errorMessage.value = '';
      validateOTPApiCall();
    }*/
    errorMessage.value = '';
    validateOTPApiCall();
  }

  //TODO: Re-send OTP API call
  Future<void> reSendOTP() async {
    final Map<String, String> params = {
      "email": Get.arguments['email'],
      "otp_type": Get.arguments['page_type'] == 'forgot_screen' ? 'password_reset': 'email_verification',
    };
    print('params $params');
    isLoading.value = true;
    final response = await BaseApiService().postRawData<VerifyOtpModel>(
      endpoint: Endpoints.resendOtp,
      fields: params,
      fromJson: (json) => VerifyOtpModel.fromJson(json),
    );
    isLoading.value = false;
    if (response.isSuccess && response.statusCode == 200) {
      print('otp valid sucess ${response.data?.data}');
      Get.snackbar('Success', response.message ?? 'OTP sent your email address');
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessage.value = response.message ?? 'Something went wrong';
      // Get.snackbar('Failed', response.message ?? 'OTP validate failed');
    }
  }

  //TODO: OTP Validate API Call
  Future<void> validateOTPApiCall() async {
    final Map<String, String> params = {
      "email": Get.arguments['email'],
      "otp_type": Get.arguments['page_type'] == 'forgot_screen' ? 'password_reset': 'email_verification',
      "otp": otpCode.value.toString()
    };
    // print('params $params');
    isLoading.value = true;
    final response = await BaseApiService().postRawData<VerifyOtpModel>(
      endpoint: Endpoints.verifyOtp,
      fields: params,
      fromJson: (json) => VerifyOtpModel.fromJson(json),
    );
    isLoading.value = false;
    if (response.isSuccess && response.statusCode == 200) {
      // print('otp valid sucess ${response.data?.message}');

      if(Get.arguments['page_type'] == 'forgot_screen'){
        Get.toNamed(
          Routes.resetPassword,
          arguments: {
            'email': response.data?.data?.email ?? '',
            'resetToken': response.data?.data?.resetToken ?? ''
          }
        );
      } else {
        await Future.wait([
          // sharedPref.saveIsLoggedIn(true),
          sharedPref.saveRefreshAuthToken(response.data?.data?.tokens?.refresh ?? ''),
          sharedPref.saveAuthToken(response.data?.data?.tokens?.access ?? '')
        ]);
        // print('OTP page $gender');
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => VideoSlide(genderType: gender,)),
        );

        /// Open next step info page
        // Get.toNamed(Routes.confirmationInfo, arguments: {
        //     'initialIndex': 0,
        //   },
        // );

        // Get.toNamed(
        //   Routes.uploadVideoPage,
        // );
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessage.value = response.message ?? 'OTP validate failed';
      // Get.snackbar('Failed', response.message ?? 'OTP validate failed');
    }
  }
}
