import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:get/get.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/routes/routes.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Form(
      key: controller.loginKey,
      child: Column(
        children: [
          SizedBox(height: 20.h,),
          Column(
            children: [
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
              ),
              ),

              SizedBox(height: 8.h,),
              Obx(() => AuthInput(
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
              ),
              /// Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.forgotPassword,
                        );
                      },
                      child: AppTextFont(
                        'Forgot Password?',
                        font: AppFontType.inter,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: theme.headerTitleColor,
                      )
                  ),
                ),
              ),
            ],
          ),

          Spacer(),
          /// Login button
          SafeArea(
            top: false,
            child: Column(
              children: [
                /// Error message
                Obx(() => controller.errorMessage.isEmpty
                    ? const SizedBox()
                    : Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      color: theme.alert,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
                SizedBox(height: 5.h,),
                Obx(
                      () => PrimaryButton(
                    title: 'Login',
                    loading: controller.isLoading.value,
                    fontWeight: FontWeight.w600,
                    onTap: controller.isLoginEnabled.value
                        ? () {
                      if (controller.loginKey.currentState!.validate()) {
                        controller.login();
                      }
                    } : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

