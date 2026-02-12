import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/splash_on_boarding%20/splash_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // LocationService.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GetBuilder<SplashController>(
      builder: (controller) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (_, __) => Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppIcons.splashImagePng),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GifView.asset(
                      AppIcons.gifLogo,
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      'REAL TRUE DATE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        // textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: MediaQuery.textScalerOf(context).scale(24),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        color: theme.text
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "WORLD'S 1st AI-POWERED\nDATING APP",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        // textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: MediaQuery.textScalerOf(context).scale(12),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          color: theme.text
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}