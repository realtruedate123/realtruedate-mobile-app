import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/controller/help_support_controller.dart';
import 'package:real_true_date/data/profile_tab/widget/faq_accordion_cell.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class HelpSupportView extends StatelessWidget {
  final HelpSupportController controller = Get.put(HelpSupportController());

  HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      appBar: TransparentBackAppBar(
        title: 'Help & Support',
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

              // Wrap the main white container in Expanded so it gets defined height
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.containerBG,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      // SizedBox(height: 12.h),

                      // Custom Reactive Tab Header
                      _buildTabBar(),

                      // Tab View Content Area
                      Expanded(
                        child: Obx(() {
                          return controller.selectedTabIndex.value == 0
                              ? _buildFaqTab(context, theme)
                              : _buildContactUsTab(context, theme);
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom Tab Bar (FAQ / Contact Us)
  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),
      // color: Colors.white, // Background color
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  title: "FAQ",
                  isSelected: controller.selectedTabIndex.value == 0,
                  onTap: () {
                    controller.selectedTabIndex.value = 0;
                  },
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  title: "Contact Us",
                  isSelected: controller.selectedTabIndex.value == 1,
                  onTap: () {
                    controller.selectedTabIndex.value = 1;
                  },
                ),
              ),
            ],
          )),
          // Divider line below tabs
          Container(
            height: 1.h,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: AppTextFont(
              title,
              font: AppFontType.manrope,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey.shade400,
              textAlign: TextAlign.center,
            ),
          ),
          // Active Tab Indicator Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.5.h,
            color: isSelected ? Colors.black : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FAQ TAB
  // =========================================================

  Widget _buildFaqTab(BuildContext context, dynamic theme) {
    return Obx(() {
      if (controller.faqModelList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
        itemCount: controller.faqModelList.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return FAQAccordionCell(
            item: controller.faqModelList[index],
            index: index,
          );
        },
      );
    });
  }

  // =========================================================
  // CONTACT US TAB
  // =========================================================

  Widget _buildContactUsTab(BuildContext context, dynamic theme) {
    final List<Map<String, dynamic>> contactOptions = [
      {
        'title': 'WhatsApp',
        'icon': AppIcons.getWhatsAppIcon(context),
        'onTap': () => controller.openWhatsApp(),
      },
      {
        'title': 'Website',
        'icon': AppIcons.getWebSiteIcon(context),
        'onTap': () {
          controller.openLinks('website');
        },
      },
      {
        'title': 'Facebook',
        'icon': AppIcons.getFacebookIcon(context),
        'onTap': () {
          controller.openLinks('facebook');
        },
      },
      {
        'title': 'Twitter',
        'icon': AppIcons.getTwitterIcon(context),
        'onTap': () => controller.openTwitter(),
      },
      {
        'title': 'Instagram',
        'icon': AppIcons.getInstagramIcon(context),
        'onTap': () {
          controller.openLinks('instagram');
        },
      },
    ];

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      itemCount: contactOptions.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final option = contactOptions[index];
        return _buildContactTile(
          title: option['title'],
          icon: option['icon'],
          onTap: option['onTap'],
        );
      },
    );
  }

  Widget _buildContactTile({
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                icon,
                SizedBox(width: 16.w),
                Expanded(
                  child: AppTextFont(
                    title,
                    font: AppFontType.manrope,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}