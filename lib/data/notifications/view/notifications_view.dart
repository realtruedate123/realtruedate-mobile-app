import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/notifications/controller/notification_controller.dart';
import 'package:real_true_date/data/notifications/widget/notification_tile.dart';
import 'package:get/get.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatelessWidget {
  final controller = Get.find<NotificationController>();

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.whiteColor,
      appBar: AppBar(
        backgroundColor: theme.whiteColor,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 63,
        title: AppTextFont(
          'Notifications',
          font: AppFontType.urbanist,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: theme.blackColor,
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: InkWell(
            splashColor: Colors.transparent, // Hides the ripple
            highlightColor: Colors.transparent, // Hides the click highlight
            onTap: () {
              Get.back();
            },
            child: AppIcons.getBackButtonIcon(context, size: 38),
          ),
          // IconButton(
          //   icon: AppIcons.getBackButtonIcon(context, size: 38),
          //   onPressed: () => Get.back(),
          // ),
        ),
        /*actions: [
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
                    // Home click event
                    print('Home clicked');
                    Get.find<RootTabController>().switchTo(0);
                  },
                  child: AppIcons.getHomeAppbar(context, size: 38),
                ),
                // IconButton(
                //   icon: AppIcons.getBackButtonIcon(context, size: 38),
                //   onPressed: () {
                //     print('click');
                //   },
                // ),
                // IconButton(
                //   icon: AppIcons.getHomeAppbar(context, size: 38),
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ],*/
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshNotifications();
          },
          child: controller.notifications.isEmpty ? Center(
            child: Text(
              'There are no notifications to display at the moment.',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ) : ListView.separated(
            controller: controller.scrollController,
            padding: const EdgeInsets.only(top: 10),
            itemCount: controller.notifications.length +
                (controller.hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final data = controller.notifications[index];
              if (index == controller.notifications.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return NotificationTile(
                  notification: data,
                onAccept: () {
                  print("Accepted ${data.conversationId}");
                  // call accept API here
                  controller.acceptOrDeclineApiCall('accept', data.conversationId ?? '');
                },

                onDecline: () {
                  print("Declined ${data.conversationId}");
                  // call decline API here
                  controller.acceptOrDeclineApiCall('decline', data.conversationId ?? '');
                },

                onMessage: () {
                  print("Open chat ${data.conversationId}");
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
