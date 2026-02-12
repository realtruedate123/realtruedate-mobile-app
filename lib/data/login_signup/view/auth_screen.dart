import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:real_true_date/data/login_signup/view/login_view.dart';
import 'package:real_true_date/data/login_signup/view/signup_step_one.dart';
import 'package:real_true_date/data/login_signup/view/signup_step_two.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_header.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_tabs.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10.h,),
                          Obx(() {
                            final isSignup = controller.currentTab.value == AuthTab.signup;

                            /// Header Title View
                            return AuthHeader(
                              title: isSignup ? 'Join TrueDate\nToday!' : 'Hello,\nWelcome Back!',
                              subtitle: isSignup ? 'Real people, real connections – powered by AI' : 'Please enter your email and password details to access your account.',
                            );
                          }),
                          // SizedBox(height: 20.h),
                          /// Login and Signup View
                          Expanded(
                            child: Container(
                                // constraints: BoxConstraints(
                                //   minHeight: MediaQuery.of(context).size.height * 0.95,
                                //   // maxHeight: MediaQuery.of(context).size.height * 0.85,
                                // ),
                              padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
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
                                    AuthTabs(controller: controller),
                                    SizedBox(height: 20.h),

                                    /// ANIMATED STEP TRANSITION
                                    Expanded(
                                      child: Obx(() {
                                        return AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 350),
                                          transitionBuilder: (child, anim) {
                                            return SlideTransition(
                                              position: Tween(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(anim),
                                              child: FadeTransition(
                                                opacity: anim,
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: controller.currentTab.value ==
                                              AuthTab.signup
                                              ? _SignupAnimated()
                                              : LoginView(),
                                        );
                                      }),
                                    ),
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
          )
        ),
      ),
    );
  }
}

class _SignupAnimated extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: controller.signupStep.value == SignupStep.step1
            ? SignupStepOne(key: const ValueKey(1))
            : SignupStepTwo(key: const ValueKey(2)),
      );
    });
  }
}
