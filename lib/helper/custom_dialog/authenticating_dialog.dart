import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/custom_dialog/common_dialog_view.dart';

class AuthenticatingDialog {

  /// ================= LOADER =================
  static void showLoader({String title = "Authenticating with AI"}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextFont(
                "Authenticating with AI",
                font: AppFontType.manrope,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              GifView.asset(
                AppIcons.gifImageVideoScan,
                height: 150,
                width: 150,
              ),
              SizedBox(height: 10),
              AppTextFont(
                "Please wait...",
                font: AppFontType.manrope,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// ================= HIDE LOADER =================
  static void hideLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// ================= ERROR POPUP =================
  static void showError(String message, {VoidCallback? onConfirmCallback,}) {
    Get.dialog(
        CommonDialogView(
          title: '',
          message: message,
          onConfirm: () {
            Get.back();
            if (onConfirmCallback != null) {
              onConfirmCallback(); // Trigger controller callback
            }
          },
        )
    );
  }
}
