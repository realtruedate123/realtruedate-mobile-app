import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_theme.dart';

class InternetDialog {
  static bool _isDialogOpen = false;

  static void showNoInternetDialog() {
    if (_isDialogOpen) return; // Prevent multiple dialogs
    _isDialogOpen = true;

    Get.defaultDialog(
      title: 'No Internet',
      titleStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 18.sp,
      ),
      middleText: 'Please check your internet connection and try again.',
      middleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
      ),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      barrierDismissible: false,
      buttonColor: AppTheme.of(Get.context!).primaryColor,
      onConfirm: () {
        _isDialogOpen = false;
        Get.back();
      },
    );
  }
}
