import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/notifications/controller/notification_controller.dart';
import 'package:real_true_date/data/notifications/widget/notification_tile.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/routes/routes.dart';

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
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshNotifications();
          },
          child: Obx(
                () => controller.notifications.isEmpty
                ? Center(
              child: Text(
                'There are no notifications to display at the moment.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.separated(
              controller: controller.scrollController,
              padding: const EdgeInsets.only(top: 10),
              itemCount: controller.notifications.length + (controller.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                // Loading indicator at the bottom
                if (index == controller.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final data = controller.notifications[index];

                return NotificationTile(
                  notification: data,
                  onAccept: () {
                    controller.acceptOrDeclineApiCall(
                      'accept',
                      data.conversationId ?? '',
                    );
                  },
                  onDecline: () {
                    controller.acceptOrDeclineApiCall(
                      'decline',
                      data.conversationId ?? '',
                    );
                  },
                  onMessage: () {
                    Get.toNamed(Routes.chatView, arguments: {
                      'conversation_id': data.conversationId
                    });
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
