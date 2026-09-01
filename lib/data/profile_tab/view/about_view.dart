import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/controller/about_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUsView extends StatelessWidget {
  AboutUsView({super.key});
  final controller = Get.put(AboutController());

  // Future<String> loadAboutText() {
  //   return rootBundle.loadString(
  //     'assets/files/about_realtrue_date.txt',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final theme = AppTheme.of(context);

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: Obx(
                          () => Stack(
                        children: [
                          SizedBox(height: 20,),
                          WebViewWidget(
                            controller: controller.webViewController,
                          ),
                    
                          if (controller.isLoading.value)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  /*child: FutureBuilder<String>(
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
                  ),*/
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
