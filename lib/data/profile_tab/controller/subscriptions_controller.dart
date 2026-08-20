import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/data/profile_tab/model/subscription_plan_model.dart';

class SubscriptionsController extends GetxController {

  // --- Loading State ---
  var isLoading = false.obs;

  final prefHelper = SharedPrefHelper();

  RxInt selectedIndex = 0.obs; // Tracks currently selected plan
  final RxList<Package> packages = <Package>[].obs;
  final RxBool isPurchasing = false.obs;

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      title: 'Unlimited',
      price: '\$69.99/per month',
      featureText: 'Unlimited Profile Swipes & Messaging',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();

    fetchOfferings();
  }

  /// Fetch paywall offerings configured in RevenueCat dashboard
  Future<void> fetchOfferings() async {
    try {
      isLoading.value = true;
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        packages.assignAll(offerings.current!.availablePackages);
        print('packages ${packages.length}');
      } else {
        Get.snackbar("Error", "No active subscription plans found.");
      }
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed to load offerings");
    } finally {
      isLoading.value = false;
    }
  }

  /// Purchase selected plan
  Future<void> makePurchase() async {
    if (packages.isEmpty) return;

    try {
      isPurchasing.value = true;
      Package selectedPackage = packages[selectedIndex.value];

      CustomerInfo customerInfo = await Purchases.purchasePackage(selectedPackage);

      // Check if user unlocked entitlement (replace 'pro' with your entitlement identifier in RevenueCat)
      if (customerInfo.entitlements.all["pro"]?.isActive == true) {
        Get.snackbar("Success", "Subscription activated successfully!");
        Get.back(); // Navigate back or to home page
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        Get.snackbar("Purchase Failed", e.message ?? "An error occurred");
      }
    } finally {
      isPurchasing.value = false;
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      CustomerInfo customerInfo = await Purchases.restorePurchases();

      if (customerInfo.entitlements.all["pro"]?.isActive == true) {
        Get.snackbar("Success", "Subscriptions restored successfully!");
      } else {
        Get.snackbar("Notice", "No active subscriptions found to restore.");
      }
    } on PlatformException catch (e) {
      Get.snackbar("Restore Failed", e.message ?? "Unable to restore purchases");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}