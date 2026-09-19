import 'package:flutter/gestures.dart';
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

                      final selectedIndex = controller.selectedIndex.value;
                      final isPurchasing = controller.isPurchasing.value;
                      final isPurchased = controller.isAlreadyPurchased.value;

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
                                print('${controller.selectedIndex.value} index $index');
                                final package = controller.packages[index];
                                final product = package.storeProduct;
                                final isSelected = selectedIndex == index;
                                // Check whether THIS package is the active subscription
                                final isActivated = isPurchased &&
                                    controller.activePackageIdentifier.value == product.identifier;

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.r),
                                  child: SubscriptionCard(
                                    title: product.title,
                                    price: '${product.pricePerMonthString}/per month',
                                    featureText: product.description,
                                    isSelected: isSelected,
                                    isActivated: isActivated,
                                    onTap: () {
                                      controller.selectedPackages(index);
                                    },
                                  ),
                                );
                              },
                            )
                          ),

                          // Bottom Action Area
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            child: Column(
                              children: [
                                PrimaryButton(
                                  title: isPurchased
                                      ? 'Already Subscribed'
                                      : isPurchasing
                                      ? 'Processing...'
                                      : 'Subscribe',
                                  onTap: (
                                      selectedIndex == -1 ||
                                          isPurchasing ||
                                          isPurchased
                                  )
                                      ? null
                                      : controller.makePurchase,
                                ),

                                SizedBox(height: 8.h),

                                TextButton(
                                  onPressed: controller.restorePurchases,
                                  child: Text(
                                    "Restore Purchases",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          SafeArea(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigate to Terms of Service
                                        controller.openTermPolicy('terms');
                                      },
                                  ),
                                  TextSpan(text: '        ', style: TextStyle(color: theme.dark)),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigate to Policy
                                        controller.openTermPolicy('policy');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h,)
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
    );
  }
}