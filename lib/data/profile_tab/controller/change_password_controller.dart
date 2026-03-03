import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();

    // Add listeners to validate on every input change
    currentPasswordCtrl.addListener(validateForm);
    newPasswordCtrl.addListener(validateForm);
    confirmPasswordCtrl.addListener(validateForm);
  }

  void validateForm() {
    // Reset errors
    currentPasswordError.value = null;
    newPasswordError.value = null;
    confirmPasswordError.value = null;

    bool valid = true;

    // Current password validation
    if (currentPasswordCtrl.text.isEmpty) {
      currentPasswordError.value = 'Current password required';
      valid = false;
    }

    // New password validation
    if (newPasswordCtrl.text.isEmpty) {
      newPasswordError.value = 'New password required';
      valid = false;
    } else if (newPasswordCtrl.text.length < 6) {
      newPasswordError.value = 'Minimum 6 characters';
      valid = false;
    }

    // Confirm password validation
    if (confirmPasswordCtrl.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm password';
      valid = false;
    } else if (confirmPasswordCtrl.text != newPasswordCtrl.text) {
      confirmPasswordError.value = 'Passwords do not match';
      valid = false;
    }

    // Update form validity
    isFormValid.value = valid;
  }

  void updatePassword() {
    if (!isFormValid.value) return;

    isLoading.value = true;
    Get.back();
    // Call API to update password
    // After API response:
    // isLoading.value = false;
    // handle errorMessage if any
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}