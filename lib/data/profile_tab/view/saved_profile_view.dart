import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/controller/saved_profile_controller.dart';
import 'package:real_true_date/data/profile_tab/widget/saved_profile_cell.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:get/get.dart';
import 'package:real_true_date/routes/routes.dart';

class SavedProfileView extends StatelessWidget {
  final controller = Get.put(SavedProfileController());
  SavedProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: AppTextFont(
          'Saved  Profiles',
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
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 16.w),
        //     child: InkWell(
        //     onTap: () {
        //         Navigator.pop(context);
        //         },
        //         child: AppIcons.getHomeAppbar(context, size: 38)),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 20.h),
          Obx(() =>
              Expanded(
                  child: controller.matchesList.isEmpty
                      ? Center(
                    child: Text(
                      'No saved profiles found',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  )
                      : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    itemCount: controller.matchesList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 5.h,
                      childAspectRatio: 0.58,
                    ),
                    itemBuilder: (context, index) {
                      return SavedProfileCell(
                        match: controller.matchesList[index],
                        onTap: () {
                          Get.toNamed(
                            Routes.savedProfileDetailsView,
                            arguments: controller.matchesList[index]
                          );
                        },
                      );
                    },
                  )

              ),
          )
            ],
          ),
        ),
      ),
    );
  }
}
