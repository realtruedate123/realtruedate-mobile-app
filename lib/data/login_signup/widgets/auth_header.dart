import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? height;

  const AuthHeader({super.key,
    this.title = 'Hello,\nWelcome Back!',
    this.subtitle =
    'Please enter your email and password details to access your account.',
    this.height
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      height: height ?? 210,//MediaQuery.of(context).size.height * 0.23,
      width: double.infinity,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 20.h, bottom: 20.h, right: 25.w, left: 25.w),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(
                  fontSize: MediaQuery.textScalerOf(context).scale(32),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  color: theme.headerTitleColor
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h,),
            Text(
              subtitle,
              style: GoogleFonts.manrope(
                  fontSize: MediaQuery.textScalerOf(context).scale(14),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  color: theme.headerTitleColor
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
