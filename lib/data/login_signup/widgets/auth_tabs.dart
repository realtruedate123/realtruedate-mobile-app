import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';

class AuthTabs extends StatelessWidget {
  final AuthController controller;

  const AuthTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Obx(
            () => Stack(
          children: [
            /// 🔹 Animated Active Pill
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: controller.currentTab.value == AuthTab.signup
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                ),
              ),
            ),

            /// 🔹 Tabs
            Row(
              children: [
                _tabItem(
                  context: context,
                  title: 'Sign Up',
                  isActive: controller.currentTab.value == AuthTab.signup,
                  onTap: () => controller.switchTab(AuthTab.signup),
                ),
                _tabItem(
                  context: context,
                  title: 'Login',
                  isActive: controller.currentTab.value == AuthTab.login,
                  onTap: () => controller.switchTab(AuthTab.login),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem({
    required BuildContext context,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = AppTheme.of(context);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.textScalerOf(context).scale(17.0),
              fontWeight: isActive ? FontWeight.w400 : FontWeight.w300,
              // color: isActive
              //     ? Color(0xFF1C2A44)
              //     : Color(0xFF8A94A6),
              color: theme.iconTintHighlightColor
            ),
          ),
        ),
      ),
    );
  }
}
