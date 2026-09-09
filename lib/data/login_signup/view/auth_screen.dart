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
      body:
        LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(), // prevents bouncing/overscroll
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ///HEADER VIEW
                        SizedBox(
                          height: 270.h, // fixed header height
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              /// HEADER IMAGE
                              Image.asset(
                                AppIcons.headerHalfImagePng,
                                fit: BoxFit.cover,
                              ),

                              /// HEADER TEXT
                              SafeArea(
                                // top: false,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        final isSignup = controller.currentTab.value == AuthTab.signup;

                                        /// Header Title View
                                        return AuthHeader(
                                          title: isSignup ? 'Join TrueDate\nToday!' : 'Hello,\nWelcome Back!',
                                          subtitle: isSignup ? 'Real people, real connections – powered by AI' : 'Please enter your email and password details to access your account.',
                                          step: isSignup,
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 20.h),
                        /// Login and Signup View
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(0, -30), // 👈 move up
                            child: Container(
                              padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
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
                                    AuthTabs(controller: controller),
                                    SizedBox(height: 20.h),
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
                                          child: controller.currentTab.value == AuthTab.signup
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
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
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
