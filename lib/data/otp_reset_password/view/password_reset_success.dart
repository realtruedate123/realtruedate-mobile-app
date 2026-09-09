import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordResetSuccess extends StatelessWidget {
  const PasswordResetSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // Remove default AppBar background
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextFont(
                    'Password Reset\nSuccessfully',
                    font: AppFontType.urbanist,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: theme.dark,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            /// BOTTOM BUTTON
            Padding(
              padding: EdgeInsets.fromLTRB(50.w, 0, 50.w, 24.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: PrimaryButton(
                  title: 'Login',
                  loading: false,
                  fontWeight: FontWeight.w600,
                    cornerRadius: true,
                  onTap: (){
                    Navigator.popUntil(context, ModalRoute.withName('/authPage'));
                  }
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
