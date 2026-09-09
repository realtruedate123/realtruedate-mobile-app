import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/otp_reset_password/model/verify_otp_model.dart';
import 'package:real_true_date/routes/routes.dart';

class ResetPasswordController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final passwordError = RxnString();
  final reTypePasswordError = RxnString();

  /// OTP state
  final otpCode = ''.obs;
  final isOtpValid = false.obs;

  /// CONTROLLERS
  final passwordCtrl = TextEditingController();
  final reTypePasswordCtrl = TextEditingController();

  /// Button enable state
  final isResetPasswordEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    passwordCtrl.addListener(_checkLoginEnable);
    reTypePasswordCtrl.addListener(_checkLoginEnable);
  }

  @override
  void onClose() {
    passwordCtrl.dispose();
    reTypePasswordCtrl.dispose();
    super.onClose();
  }

  void _checkLoginEnable() {
    isResetPasswordEnabled.value =
        passwordCtrl.text.isNotEmpty && reTypePasswordCtrl.text.isNotEmpty;
  }

  void resetPassword() {
    passwordError.value = null;
    reTypePasswordError.value = null;
    errorMessage.value = '';

    if (passwordCtrl.text.length < 8) {
      passwordError.value = 'This password is too short. It must contain at least 8 characters.';
      return;
    }
    if (reTypePasswordCtrl.text.length < 8) {
      reTypePasswordError.value = 'This password is too short. It must contain at least 8 characters.';
      return;
    }
    if(passwordCtrl.text != reTypePasswordCtrl.text){
      errorMessage.value = 'password does not match';
    }
    else{
      resetPasswordApiCall();
    }
  }

  //TODO: Reset password API call
  Future<void> resetPasswordApiCall() async {
    final Map<String, String> params = {
      "email": Get.arguments['email'],
      "reset_token": Get.arguments['resetToken'],
      "new_password": passwordCtrl.text,
      "confirm_password": reTypePasswordCtrl.text
    };
    isLoading.value = true;
    final response = await BaseApiService().postRawData<VerifyOtpModel>(
      endpoint: Endpoints.resetPassword,
      fields: params,
      fromJson: (json) => VerifyOtpModel.fromJson(json),
    );
    isLoading.value = false;
    if (response.isSuccess && response.statusCode == 200) {
      Get.toNamed(
        Routes.passwordResetSuccess,
      );
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessage.value = response.message ?? 'Something went wrong';
    }
  }
}
