import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/login_signup/model/register_model.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/routes/routes.dart';

class ForgotPasswordController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final emailError = RxnString();

  /// CONTROLLERS
  final emailCtrl = TextEditingController();

  /// Button enable state
  final isLoginEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();

    emailCtrl.addListener(_checkLoginEnable);
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }

  void _checkLoginEnable() {
    isLoginEnabled.value = emailCtrl.text.isNotEmpty;
  }

  void forgotPassword(){
    emailError.value = null;
    errorMessage.value = '';
    if(validateEmail(emailCtrl.text) == false){
      emailError.value = 'Enter a valid email address';
      isLoading.value = false;
      return;
    }
    else{
      forgotPasswordApiCall();
    }
  }

  //TODO: Forgot password API Call
  Future<void> forgotPasswordApiCall() async {
    final params = {
      "email": emailCtrl.text,
    };

    final response = await BaseApiService().postRawData<RegisterResponseModel>(
      endpoint: Endpoints.forgotPassword,
      fields: params,
      fromJson: (json) => RegisterResponseModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      Get.toNamed(
          Routes.otpScreen,
          arguments: {
            'email': response.data?.data?.email ?? '',
            'otp': response.data?.data?.otp.toString(),
            'page_type': 'forgot_screen'
          }
      );
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessage.value = response.message ?? 'Something went wrong';
    }
  }
}
