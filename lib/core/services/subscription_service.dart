import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:real_true_date/helper/custom_dialog/upgrade_plan_dialog_view.dart';
import 'package:real_true_date/routes/routes.dart';

class SubscriptionService {
  static final SubscriptionService _instance =
  SubscriptionService._internal();

  factory SubscriptionService() => _instance;

  SubscriptionService._internal();

  bool checkSubscription({
    required bool? isExpired,
    required bool? isPremium,
    required int? freeSwipesUsed,
    required int? freeSwipesLimit,
  }) {
    if (isExpired == true) {
      subscriptionAlert(
        StringMessage.subscriptionExpiredTitle,
        StringMessage.subscriptionExpiredMessage,
      );
      return true;;
    }

    if (isPremium == false &&
        (freeSwipesUsed ?? 0) >= (freeSwipesLimit ?? 0)) {
      subscriptionAlert(
        StringMessage.freeSwapeTitle,
        StringMessage.freeSwapeMessage,
      );
      return true;
    }

    print('no message');
    return false;
  }

  void subscriptionAlert(String title, String message){
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => UpgradePlanDialogView(
        title: title,
        message: message,
        confirmText: 'Upgrade Plan',
        onConfirm: () {
          print('Upgrade Plan');
          Get.back();
          Get.toNamed(Routes.subscriptionView);
        },
      ),
    );
  }
}
