import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:real_true_date/data/home_tab/controller/home_tab_controller.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/profile_tab/model/subscription_plan_model.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/helper/custom_dialog/common_dialog_view.dart';

class SubscriptionsController extends GetxController {

  // --- Loading State ---
  var isLoading = false.obs;

  final prefHelper = SharedPrefHelper();

  RxInt selectedIndex = (-1).obs; // Tracks currently selected plan
  RxBool isAlreadyPurchased = true.obs;
  final RxList<Package> packages = <Package>[].obs;
  final RxBool isPurchasing = false.obs;
  final RxString activePackageIdentifier = ''.obs;
  var userID = '';

  @override
  void onInit() {
    super.onInit();

    getUserData();
    fetchOfferings();
    // checkSubscriptionStatus();
  }

  /// Get saved local user data
  void getUserData() async {
    try {
      // Fetch from API or storage
      userID = await prefHelper.getUserId;
      AppState.instance.loginUserID = userID;

      // Associate RevenueCat with your user
      await Purchases.logIn(AppState.instance.loginUserID ?? userID);

    } finally {
    }
  }

  void selectedPackages(int index){
    selectedIndex.value = index;
  }

  /// Fetch paywall offerings configured in RevenueCat dashboard
  Future<void> fetchOfferings() async {
    try {
      isLoading.value = true;
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        packages.assignAll(offerings.current!.availablePackages);

        /*print('packages ${packages.length}');
        print('price ${packages.first.storeProduct.price}');
        print('title ${packages.first.storeProduct.title}');
        print('description ${packages.first.storeProduct.description}');*/

        /*for (final package in packages) {
          print('Package ID: ${package.identifier}');
          print('Product ID: ${package.storeProduct.identifier}');
          print('Price: ${package.storeProduct.priceString}');
          print('Title: ${package.storeProduct.title}');
          print('Description: ${package.storeProduct.description}');
        }*/

        // Get user's current subscription
        final CustomerInfo customerInfo = await Purchases.getCustomerInfo();

        if (customerInfo.entitlements.active.isNotEmpty) {
          for (final entitlement in customerInfo.entitlements.active.values) {
            print('-------------------------');
            print('Active Entitlement: ${entitlement.identifier}');
            print('Purchased Product ID: ${entitlement.productIdentifier}');
            print('Expiration: ${entitlement.expirationDate}');
            print('-------------------------');

            // Find matching package from offerings
            // final activePackage = packages.firstWhereOrNull((package) =>
            //   package.storeProduct.identifier == entitlement.productIdentifier,
            // );

            final activePackageIndex = packages.indexWhere((package) =>
              package.storeProduct.identifier == entitlement.productIdentifier,
            );

            if (activePackageIndex != -1) {
              final activePackage = packages[activePackageIndex];
              print('Active Package: ${activePackage.identifier}',);
              print('Active Package Price: ''${activePackage.storeProduct.priceString}',);

              activePackageIdentifier.value = entitlement.productIdentifier;
              isAlreadyPurchased.value = true;
              selectedIndex.value = activePackageIndex;

              Get.dialog(
                  CommonDialogView(
                    title: '',
                    message: 'Subscription activated successfully!',
                    onConfirm: () {  },
                    onCancel: () async {
                      Get.back();
                      await Future.delayed(const Duration(seconds: 1));
                      Get.back();
                      if (Get.isRegistered<HomeTabController>()) {
                        final controller = Get.find<HomeTabController>();
                        controller.getApiData();
                        controller.getFeedListApiCall(); // load initial state
                      }
                      Get.find<RootTabController>().switchTo(0); // always reset to home
                    },
                  )
              );
            }
          }
        } else {
          isAlreadyPurchased.value = false;
          activePackageIdentifier.value = '';
          print('No active subscription');
        }
      } else {
        isAlreadyPurchased.value = false;
        activePackageIdentifier.value = '';
        Get.snackbar("Error", "No active subscription plans found.");
      }
    } on PlatformException catch (e) {
      isAlreadyPurchased.value = false;
      activePackageIdentifier.value = '';
      Get.snackbar("Error", e.message ?? "Failed to load offerings");
    } finally {
      isLoading.value = false;
    }
  }

  /// Status Subscription
  /*Future<void> checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();

      // Get active entitlements
      final activeEntitlements = customerInfo.entitlements.active;

      final entitlement = customerInfo.entitlements.all["Real True Date Pro"];
      print('Subscription active ${entitlement?.isActive}');

      if (activeEntitlements.isNotEmpty) {
        isAlreadyPurchased.value = true;

        // If you have only ONE entitlement, you can use first
        final entitlement = activeEntitlements.values.first;

        print("Active Package: ${entitlement.identifier}");
        print("Product ID: ${entitlement.productIdentifier}");
        print("Expiration: ${entitlement.expirationDate}");
        print("Expiration: ${entitlement.isActive}");

        activePackageIdentifier.value = entitlement.productIdentifier;
        selectedIndex.value = 0;

        print('Already purchased: ${isAlreadyPurchased.value}');
        print(
          'Active product: ${activePackageIdentifier.value}',
        );
      } else {
        isAlreadyPurchased.value = false;
        activePackageIdentifier.value = '';

        print('No active subscription');
      }
    } on PlatformException catch (e) {
      print('Subscription status error: ${e.message}');

      isAlreadyPurchased.value = false;
      activePackageIdentifier.value = '';
    }
  }*/


  /// Purchase selected plan
  Future<void> makePurchase() async {
    if (packages.isEmpty) return;

    EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      isPurchasing.value = true;
      Package selectedPackage = packages[selectedIndex.value];

      final PurchaseResult result = await Purchases.purchase(
        PurchaseParams.package(selectedPackage),
      );

      final CustomerInfo customerInfo = result.customerInfo;
      final StoreTransaction transaction = result.storeTransaction;
      print('transaction 1: $transaction');

      print("RevenueCat App User ID: ${customerInfo.originalAppUserId}");
      print("Active entitlements: ${customerInfo.entitlements.active.keys}");

      final activeEntitlements = customerInfo.entitlements.active;
      if (activeEntitlements.isNotEmpty) {
        final entitlement = activeEntitlements.values.first;

        isAlreadyPurchased.value = true;
        activePackageIdentifier.value = entitlement.productIdentifier;
        print('Purchased 1: ${activePackageIdentifier.value}',);
      }

      /*customerInfo.entitlements.all.forEach((key, entitlement) {
        print('Entitlement: $key');
        print('  Active: ${entitlement.isActive}');
        print('  Product ID: ${entitlement.productIdentifier}');
        print('  Expiration: ${entitlement.expirationDate}');
        print('  Will renew: ${entitlement.willRenew}');
      });*/

      // Build backend payload
      /*final Map<String, dynamic> payload = {
        "app_user_id": customerInfo.originalAppUserId,

        "product_id": selectedPackage.storeProduct.identifier,

        "package_identifier": selectedPackage.identifier,
        "transaction": {
          "product_identifier": transaction.productIdentifier,
          "transaction_identifier": transaction.transactionIdentifier,
        },

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
      print("Backend Payload: ${customerInfo.latestExpirationDate}");
      print(payload);*/

      print('Real True Date Pro ==== ${customerInfo.entitlements.all["Real True Date Pro"]?.isActive == true}');

      // Check if user unlocked entitlement (replace 'pro' with your entitlement identifier in RevenueCat)
      if (customerInfo.entitlements.all["Real True Date Pro"]?.isActive == true) {
        print('Subscription activated successfully!');

        print('originalAppUserId ${customerInfo.originalAppUserId}');
        print('productIdentifier ${transaction.productIdentifier}');
        print('transactionIdentifier ${transaction.transactionIdentifier}');

        getUserDataApiCall();

        /// Subscription Save Api Call
        // subscriptionSaveApiCall(transaction.productIdentifier, transaction.transactionIdentifier);

        // Get.snackbar("Success", "Subscription activated successfully!",
        //     backgroundColor: Colors.green,
        //     colorText: Colors.white
        // );
        // Get.back(); // Navigate back or to home page
      }
    } on PlatformException catch (e) {
      EasyLoading.dismiss();
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print('Purchase Failed');
        Get.snackbar("Purchase Failed", e.message ?? "An error occurred",
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
      }
    } finally {
      EasyLoading.dismiss();
      isPurchasing.value = false;
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    EasyLoading.show(
      status: 'Restoring...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();

      if (customerInfo.entitlements.all["Real True Date Pro"]?.isActive == true) {
        getUserDataApiCall();
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
      EasyLoading.dismiss();
      Get.snackbar("Restore Failed", e.message ?? "Unable to restore purchases",
          backgroundColor: Colors.red,
          colorText: Colors.white
      );
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  //TODO: Subscription save API Call
  /*Future<void> subscriptionSaveApiCall(String packageIdentifier, String transactionID) async {
    final token = await prefHelper.getAuthToken;

    final params = {
      "package_identifier": packageIdentifier,
      "transaction": {
        "transaction_identifier": transactionID
      }
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    final response = await BaseApiService().postRawData<SubscriptionSaveModel>(
      endpoint: Endpoints.subscriptionSave,
      fields: params,
      headers: header,
      fromJson: (json) => SubscriptionSaveModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          subscriptionSaveApiCall(packageIdentifier, transactionID);
        }
      } else {
        Get.snackbar("Purchases Failed", response.message ?? "Unable to purchases",
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
      }
    }
  }*/

  Future<void> getUserDataApiCall() async {
    final authToken = await prefHelper.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<LoginModel>(
      endpoint: Endpoints.meApi,
      headers: header,
      showLoader: false,
      fromJson: (json) => LoginModel.fromJson(json),
    );

    print('Get me api $header');

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      print('get me ${response.data?.data?.user?.id}');
      await Future.wait([
        prefHelper.savePersonList(response.data!.data!),
      ]);
      AppState.instance.loginUserID = response.data!.data?.user?.id ?? '';
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getUserDataApiCall();
        }
      } else {
        // Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
  }
}