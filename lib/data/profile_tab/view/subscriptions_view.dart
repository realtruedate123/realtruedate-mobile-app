import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/profile_tab/controller/subscriptions_controller.dart';
import 'package:real_true_date/data/profile_tab/widget/subscription_card.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class SubscriptionsView extends GetView<SubscriptionsController> {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      appBar: TransparentBackAppBar(
        title: 'Subscriptions',
        titleStyle: TextStyle(
          fontFamily: AppFontType.urbanist.toString(),
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.containerBG,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.packages.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("No plans available right now."),
                                SizedBox(height: 12.h),
                                TextButton(
                                  onPressed: controller.fetchOfferings,
                                  child: const Text("Retry"),
                                )
                              ],
                            ),
                          );
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  top: 50.r,
                                  bottom: 24.r,
                                  left: 20.r,
                                  right: 20.r,
                                ),
                                itemCount: controller.packages.length,
                                itemBuilder: (context, index) {
                                  final package = controller.packages[index];
                                  final product = package.storeProduct;
                                  final isSelected =
                                      controller.selectedIndex.value == index;

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.r),
                                    child: SubscriptionCard(
                                      title: product.title,
                                      price: '${product.priceString}/${product.subscriptionPeriod ?? "month"}',
                                      featureText: product.description,
                                      isSelected: isSelected,
                                      onTap: () {
                                        controller.selectedIndex.value = index;
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Bottom Action Area
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 16.h,
                              ),
                              child: Column(
                                children: [
                                  Obx(() => PrimaryButton(
                                    title: controller.isPurchasing.value
                                        ? 'Processing...'
                                        : 'Subscribe',
                                    onTap: controller.isPurchasing.value
                                        ? null
                                        : () => controller.makePurchase(),
                                  )),
                                  SizedBox(height: 8.h),
                                  TextButton(
                                    onPressed: controller.restorePurchases,
                                    child: Text(
                                      "Restore Purchases",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })
                    ),
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