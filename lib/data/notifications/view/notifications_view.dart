import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/notifications/controller/notification_controller.dart';
import 'package:real_true_date/data/notifications/widget/notification_tile.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/app_text_font.dart';

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
        title: AppTextFont(
          'Notifications',
          font: AppFontType.urbanist,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: theme.blackColor,
        ),
        leading: IconButton(
          icon: AppIcons.getBackButtonIcon(context, size: 38),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: AppIcons.getBackButtonIcon(context, size: 38),
            onPressed: () {},
          ),
          IconButton(
            icon: AppIcons.getHomeAppbar(context, size: 38),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        itemCount: controller.notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return NotificationTile(notification: controller.notifications[index]);
        },
      ),
    );
  }
}
