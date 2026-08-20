import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

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
      appBar: TransparentBackAppBar(
        title: 'About Us',
        titleStyle: TextStyle(
          fontFamily: AppFontType.urbanist.toString(),
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
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
              SizedBox(height: 50.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                  ),
                  child: FutureBuilder<String>(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
