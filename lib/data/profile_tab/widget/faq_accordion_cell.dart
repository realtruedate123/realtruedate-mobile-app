import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/controller/help_support_controller.dart';
import 'package:real_true_date/data/profile_tab/model/help_faq_model.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class FAQAccordionCell extends StatelessWidget {
  final FAQObjectModel item;
  final int index;

  FAQAccordionCell({super.key, required this.item, required this.index,});

  final controller = Get.find<HelpSupportController>();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Obx(() {
      // final bool isOpen = item.isExpanded.value;
      final bool isOpen = controller.expandedIndex.value == index;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: theme.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question Trigger Bar
            ListTile(
              onTap: () => controller.toggle(index),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              title: Text(
                item.question ?? '',
                style: TextStyle(
                  fontSize: MediaQuery.textScalerOf(context).scale(14),
                  // fontFamily: AppFonts.sfProRoundedRegular,
                  fontWeight: FontWeight.w600,
                  color: theme.blackColor,
                ),
              ),
              trailing: AnimatedRotation(
                turns: isOpen ? 0.5 : 0.0, // Rotates smooth downwards
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF1A1A1A),
                  size: 24.r,
                ),
              ),
            ),

            // Expandable Content Box Area Window Panel
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 16.h),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: theme.border, width: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Text(
                    item.answer ?? '',
                    style: TextStyle(
                      fontSize: MediaQuery.textScalerOf(context).scale(12),
                      // fontFamily: AppFonts.sfProRoundedRegular,
                      fontWeight: FontWeight.w400,
                      color: theme.hintText,
                    ),
                  ),
                ),
              ),
              crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      );
    });
  }
}