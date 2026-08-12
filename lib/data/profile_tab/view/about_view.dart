import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  Future<String> loadAboutText() {
    return rootBundle.loadString(
      'assets/files/about_realtrue_date.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: AppTextFont(
          'About Us',
          font: AppFontType.urbanist,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: theme.blackColor,
        ),
        leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child:  InkWell(
              onTap: () {
                Navigator.pop(context);
              }
              ,
              child: AppIcons.getBackButtonIcon(context, size: 38),)
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<String>(
        future: loadAboutText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load About Us content.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(
              snapshot.data ?? '',
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
                color: Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }
}
