import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:get/get.dart';
import 'package:real_true_date/data/message_tab/controller/message_tab_controller.dart';
import 'package:real_true_date/data/message_tab/widget/message_list_cell.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/routes/routes.dart';

class MessageTabView extends StatelessWidget {
  final controller = Get.put(MessageTabController());
  MessageTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.offWhiteBGColor,
      // Remove default AppBar background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: theme.offWhiteBGColor,
        elevation: 0,
        centerTitle: true,
        // leadingWidth: 63,
        title: AppTextFont(
          'Messages',
          font: AppFontType.urbanist,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: theme.blackColor,
        ),
        // leading: Padding(
        //   padding: EdgeInsets.only(left: 16.w),
        //   child: InkWell(
        //     splashColor: Colors.transparent, // Hides the ripple
        //     highlightColor: Colors.transparent, // Hides the click highlight
        //     onTap: () {
        //       Get.back();
        //     },
        //     child: AppIcons.getBackButtonIcon(context, size: 38),
        //   ),
        // ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent, // Hides the ripple
                  highlightColor: Colors.transparent, // Hides the click highlight
                  onTap: () {
                    // Fav click event
                    print('clicked');
                  },
                  child: AppIcons.getFavouriteIcon(context, size: 38),
                ),
                SizedBox(width: 12.w),
                InkWell(
                  splashColor: Colors.transparent, // Hides the ripple
                  highlightColor: Colors.transparent, // Hides the click highlight
                  onTap: () {
                    print('clicked');
                  },
                  child: AppIcons.getNotificationIcon(context, size: 38),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _searchBar(context),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.chatList.length,
                separatorBuilder: (_, __) => Divider(
                  color: theme.border,
                  height: 30.h,
                ),
                itemBuilder: (context, index) {
                  final chat = controller.chatList[index];
                  return MessageListCell(
                    chatList: chat,
                    onTap: () {
                      print('chat ${chat.name}');
                      Get.toNamed(Routes.chatView);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _searchBar(BuildContext context) {
  final theme = AppTheme.of(context);

  return Padding(
    padding: EdgeInsets.all(20.r),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 52.h,
      decoration: BoxDecoration(
        color: theme.whiteColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          AppIcons.getSearchIcon(context),
          SizedBox(width: 10.h),
          AppTextFont(
            'Search',
            font: AppFontType.nunitoSans,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.inactiveTabColor,
          )
        ],
      ),
    ),
  );
}

