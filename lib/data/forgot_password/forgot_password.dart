import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/forgot_password/forgot_password_controller.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_header.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';
import 'package:real_true_date/routes/routes.dart';

class ForgotPassword extends GetView<ForgotPasswordController> {
  const ForgotPassword({super.key});

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
                title: 'Forgot  Password',
                subtitle: 'Please enter your email and get the otp on you email',
                height: 140,
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
                        /// Forgot password View
                        SizedBox(height: 15.h,),
                        Obx(() => AuthInput(
                          hint: 'Email Address',
                          controller: controller.emailCtrl,
                          icon: AppIcons.getEmailIcon(context),
                          keyboardType: TextInputType.emailAddress,
                          errorText: controller.emailError.value,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email required';
                            if (!GetUtils.isEmail(v)) return 'Invalid email address';
                            return null;
                          },
                        ),),
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

                        SizedBox(height: 20.h,),

                        /// Send OTP button
                        Obx(
                              () => PrimaryButton(
                            title: 'Send OTP',
                            loading: controller.isLoading.value,
                                fontWeight: FontWeight.w600,
                            onTap: controller.isLoginEnabled.value
                                ? () {
                              // if (controller.loginKey.currentState!.validate()) {
                              // controller.login();
                              // }
                              print('click ${controller.emailCtrl.text}');
                              controller.forgotPassword();

                            } : null,
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
