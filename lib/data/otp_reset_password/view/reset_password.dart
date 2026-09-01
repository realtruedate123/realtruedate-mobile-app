import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_header.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/otp_reset_password/controller/reset_password_controller.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class ResetPassword extends GetView<ResetPasswordController> {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // Remove default AppBar background
      extendBodyBehindAppBar: true,
      appBar: TransparentBackAppBar(),
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
              /// Header Title View
              AuthHeader(
                title: 'Reset Password',
                subtitle: 'Create a new password to regain access to your account',
                height: 150,
              ),
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
                      top: false, // only bottom safe area inside
                      child: Column(
                        children: [
                          /// Reset password View
                          SizedBox(height: 15.h,),
                          Expanded(
                            child: Column(
                              children: [
                                AuthInput(
                                  hint: 'Password',
                                  controller: controller.passwordCtrl,
                                  icon: AppIcons.getPasswordIcon(context),
                                  isPassword: true,
                                  errorText: controller.passwordError.value,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Password required';
                                    if (v.length < 6) return 'Minimum 6 characters';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 5.h,),
                                AuthInput(
                                  hint: 'Retype Password',
                                  controller: controller.reTypePasswordCtrl,
                                  icon: AppIcons.getPasswordIcon(context),
                                  isPassword: true,
                                  errorText: controller.reTypePasswordError.value,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Retype password required';
                                    if (v.length < 6) return 'Minimum 6 characters';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 50.h,),
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
                          SizedBox(height: 10.h,),
                          /// Send OTP button
                          SafeArea(
                            top: false,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 20.h,
                              ),
                              child: Obx(
                                    () => PrimaryButton(
                                  title: 'Reset Password',
                                  loading: controller.isLoading.value,
                                  fontWeight: FontWeight.w600,
                                  onTap: controller.isResetPasswordEnabled.value
                                      ? () {
                                    // if (controller.loginKey.currentState!.validate()) {
                                    // controller.login();
                                    // }
                                    controller.resetPassword();
                                    // print('click reset password');

                                  } : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
