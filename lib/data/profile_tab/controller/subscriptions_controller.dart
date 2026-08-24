import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:real_true_date/core/local/shared_pref.dart';

class SubscriptionsController extends GetxController {

  // --- Loading State ---
  var isLoading = false.obs;

  final prefHelper = SharedPrefHelper();

  RxInt selectedIndex = 0.obs; // Tracks currently selected plan
  final RxList<Package> packages = <Package>[].obs;
  final RxBool isPurchasing = false.obs;

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
        print('price ${packages.first.storeProduct.price}');
        print('title ${packages.first.storeProduct.title}');
        print('description ${packages.first.storeProduct.description}');

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

      final PurchaseResult result = await Purchases.purchase(
        PurchaseParams.package(selectedPackage),
      );

      final CustomerInfo customerInfo = result.customerInfo;
      customerInfo.entitlements.all.forEach((key, entitlement) {
        print('Entitlement: $key');
        print('  Active: ${entitlement.isActive}');
        print('  Product ID: ${entitlement.productIdentifier}');
        print('  Expiration: ${entitlement.expirationDate}');
        print('  Will renew: ${entitlement.willRenew}');
      });

      // Build backend payload
      final Map<String, dynamic> payload = {
        "app_user_id": customerInfo.originalAppUserId,

        "product_id": selectedPackage.storeProduct.identifier,

        "package_identifier": selectedPackage.identifier,

        "entitlements": customerInfo.entitlements.all.map(
              (key, entitlement) => MapEntry(key, {
            "identifier": entitlement.identifier,
            "is_active": entitlement.isActive,
            "product_identifier": entitlement.productIdentifier,
            "expiration_date": entitlement.expirationDate,
            "will_renew": entitlement.willRenew,
            "unsubscribe_detected_at": entitlement.unsubscribeDetectedAt,
            "billing_issue_detected_at": entitlement.billingIssueDetectedAt,
          }),
        ),
      };

      print("Backend Payload:");
      print(payload);

      // Check if user unlocked entitlement (replace 'pro' with your entitlement identifier in RevenueCat)
      if (customerInfo.entitlements.all["Real True Date Pro"]?.isActive == true) {
        print('Subscription activated successfully!');
        Get.snackbar("Success", "Subscription activated successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white
        );
        Get.back(); // Navigate back or to home page
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print('Purchase Failed');
        Get.snackbar("Purchase Failed", e.message ?? "An error occurred",
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
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

      if (customerInfo.entitlements.all["Real True Date Pro"]?.isActive == true) {
        Get.snackbar("Success", "Subscriptions restored successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white
        );
      } else {
        Get.snackbar("Notice", "No active subscriptions found to restore.",
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
      }
    } on PlatformException catch (e) {
      Get.snackbar("Restore Failed", e.message ?? "Unable to restore purchases",
          backgroundColor: Colors.red,
          colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}