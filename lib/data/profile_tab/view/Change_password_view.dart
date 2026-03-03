import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_header.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/profile_tab/controller/change_password_controller.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: TransparentBackAppBar(title: 'Change Password',),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppIcons.headerImagePng),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
            SizedBox(height: 40.h,),

              /// Form Card
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [

                        /// Current Password
                        Obx(() => AuthInput(
                          hint: 'Current Password',
                          controller: controller.currentPasswordCtrl,
                          icon: AppIcons.getPasswordIcon(context),
                          isPassword: true,
                          errorText: controller.currentPasswordError.value,
                          // onChanged: controller.clearCurrentPasswordError,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Current password required';
                            return null;
                          },
                        )),

                        SizedBox(height: 5.h),

                        /// New Password
                        Obx(() => AuthInput(
                          hint: 'New Password',
                          controller: controller.newPasswordCtrl,
                          icon: AppIcons.getPasswordIcon(context),
                          isPassword: true,
                          errorText: controller.newPasswordError.value,
                          // onChanged: controller.clearNewPasswordError,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'New password required';
                            if (v.length < 6) return 'Minimum 6 characters';
                            return null;
                          },
                        )),

                        SizedBox(height: 5.h),

                        /// Confirm Password
                        Obx(() => AuthInput(
                          hint: 'Confirm Password',
                          controller: controller.confirmPasswordCtrl,
                          icon: AppIcons.getPasswordIcon(context),
                          isPassword: true,
                          errorText: controller.confirmPasswordError.value,
                          // onChanged: controller.clearConfirmPasswordError,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please confirm password';
                            if (v != controller.newPasswordCtrl.text) return 'Passwords do not match';
                            return null;
                          },
                        )),

                        SizedBox(height: 30.h),

                        /// Error message
                        Obx(() => controller.errorMessage.isEmpty
                            ? const SizedBox()
                            : Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: theme.alert,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),

                        Spacer(),

                        /// Update Password button
                        Obx(() => PrimaryButton(
                          title: 'Change Password',
                          loading: controller.isLoading.value,
                          fontWeight: FontWeight.w600,
                          onTap: controller.isFormValid.value
                              ? () => controller.updatePassword()
                              : null,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}