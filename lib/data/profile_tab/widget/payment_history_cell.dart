import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/model/payment_history_model.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/date_time.dart';

class PaymentHistoryCell extends StatelessWidget {
  final HistoryData transaction;

  const PaymentHistoryCell({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final String formattedAmount = transaction.amountFormatted ?? '';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Credit Card Icon Box
          AppIcons.getSubscriptionsIcon(Get.context!, size: 38),
          SizedBox(width: 16.w),

          // Title & Time Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                AppTextFont(
                  transaction.title ?? '',
                  font: AppFontType.manrope,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.blackColor,
                ),
                SizedBox(height: 8.h),
                AppTextFont(
                  TimeAgoHelper.format(transaction.purchasedAt ?? ''),
                  font: AppFontType.manrope,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.hintText,
                ),
              ],
            ),
          ),

          // Amount Text
          AppTextFont(
            formattedAmount,
            font: AppFontType.manrope,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD32F2F),
          ),
        ],
      ),
    );
  }
}