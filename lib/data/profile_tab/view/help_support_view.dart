import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/controller/help_support_controller.dart';
import 'package:real_true_date/data/profile_tab/widget/contact_support_card.dart';
import 'package:real_true_date/data/profile_tab/widget/faq_accordion_cell.dart';
import 'package:real_true_date/data/profile_tab/widget/save_profile_app_bar.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class HelpSupportView extends StatelessWidget {
  final HelpSupportController controller = Get.put(HelpSupportController());

  HelpSupportView({super.key});

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
          'Help & Support',
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: CONTACT SUPPORT GRID WRAPPER COMPONENT ---
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                      offset: Offset(0,2)
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFont(
                    "Contact Support",
                    font: AppFontType.manrope,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      /*ContactSupportCard(
                        icon: AppIcons.getHelpCallIcon(context, size: 45),
                        title: "Call Us",
                        subtitle: "Mon-Fri 9am-6pm",
                        onTap: () {
                          controller.makePhoneCall('1234567890');
                        },
                      ),
                      SizedBox(width: 14.w),*/
                      ContactSupportCard(
                        icon: AppIcons.getHelpMailIcon(context, size: 45),
                        title: "Email US",
                        subtitle: "Reply within 24hrs",
                        onTap: (){
                          controller.openEmail(
                            to: 'realtruedate@gmail.com',
                            subject: 'Need Help',
                            body: 'Hello,\n\n',
                          );
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // --- SECTION 2: ACCORDION LIST WRAPPER COMPONENT ---
            Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                      offset: Offset(0,2)
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFont(
                    "Frequently Asked Questions",
                    font: AppFontType.manrope,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.faqModelList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.faqModelList.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return FAQAccordionCell(
                            item: controller.faqModelList[index],
                          index: index,
                        );
                      },
                    );
                  }),
                  SizedBox(height: 15.h,)
                ],
              ),
            ),
            SizedBox(height: 15.h,)
          ],
        ),
      ),
    );
  }
}