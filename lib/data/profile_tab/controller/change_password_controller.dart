import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:real_true_date/helper/custom_dialog/common_dialog_view.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final currentPasswordError = RxnString();
  final newPasswordError = RxnString();
  final confirmPasswordError = RxnString();
  final errorMessage = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isFormValid = false.obs;

  final sharedPref = SharedPrefHelper();

  final currentTouched = false.obs;
  final newTouched = false.obs;
  final confirmTouched = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners to validate on every input change
    currentPasswordCtrl.addListener(validateForm);
    newPasswordCtrl.addListener(validateForm);
    confirmPasswordCtrl.addListener(validateForm);
  }

  void validateForm() {
    // Update form validity
    isFormValid.value = currentPasswordCtrl.text.isNotEmpty &&
        newPasswordCtrl.text.isNotEmpty &&
        confirmPasswordCtrl.text.isNotEmpty;
  }

  void updatePassword() {
    // Reset errors
    currentPasswordError.value = null;
    newPasswordError.value = null;
    confirmPasswordError.value = null;

    // Current password validation
    if (currentPasswordCtrl.text.isEmpty) {
      currentPasswordError.value = 'Current password required';
      return;
    }

    // New password validation
    if (newPasswordCtrl.text.isEmpty) {
      newPasswordError.value = 'New password required';
      return;
    } else if (newPasswordCtrl.text.length < 6) {
      newPasswordError.value = 'Minimum 6 characters';
      return;
    }

    // Confirm password validation
    if (confirmPasswordCtrl.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm password';
      return;
    } else if (confirmPasswordCtrl.text != newPasswordCtrl.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return;
    }

    if (!isFormValid.value) return;

    isLoading.value = true;
    // Get.back();

    changePasswordApiCall();

    // Call API to update password
    // After API response:
    // isLoading.value = false;
    // handle errorMessage if any
  }

  //TODO: Change password API Call
  Future<void> changePasswordApiCall() async {
    final token = await sharedPref.getAuthToken;

    final params = {
      "old_password": currentPasswordCtrl.text,
      "new_password": newPasswordCtrl.text,
      "retype_password": confirmPasswordCtrl.text,
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    errorMessage.value = '';

    final response = await BaseApiService().postRawData<CommonModel>(
      endpoint: Endpoints.changePassword,
      fields: params,
      headers: header,
      fromJson: (json) => CommonModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      currentPasswordCtrl.text = '';
      newPasswordCtrl.text = '';
      confirmPasswordCtrl.text = '';

      print("Response data: ${response.data?.message}");
      Get.dialog(
          CommonDialogView(
            title: 'Success',
            message: response.message ?? 'Password has been changed',
            onConfirm: () {  },
            onCancel: (){
              Get.back();
              Future.delayed(const Duration(seconds: 1), () async {
                Get.back();
              });
            },
          )
      );
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          changePasswordApiCall();
        }
      } else {
        errorMessage.value =  response.message ??  'Password has not changed failed';
      }

      // Get.snackbar('Failed', response.message ?? 'Password has not changed failed',
      //   colorText: Colors.white,
      //   backgroundColor: Colors.red
      // );
    }
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}