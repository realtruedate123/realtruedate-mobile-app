import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/helper/bottom_nav_wrapper.dart';
import 'package:real_true_date/routes/routes.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final sharedPref = SharedPrefHelper();

  @override
  void onInit() {
    super.onInit();

    // fetchCurrentLocation();

    /// Navigate after delay
    Future.delayed(const Duration(seconds: 2), () async {
      final user = await sharedPref.getPersonList();

      if (user != null && user.user?.id != null && user.user?.id != '') {
        print('user ID ${user.user?.id}');
        // print('user ID ${user.user?.toJson()}');

        // User is logged in
        Get.offAll(() => BottomNavWrapper());
      } else {
        // User not logged in -> go to onboarding
        Get.offAllNamed(Routes.onBoarding);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Fetch current location once
  // Future<void> fetchCurrentLocation() async {
  //   try {
  //     final pos = await LocationService.getCurrentLocation();
  //     if (pos != null) {
  //       print('Splash page Location $pos');
  //
  //       TemporaryValue.userLat = pos.latitude;
  //       TemporaryValue.userLng = pos.longitude;
  //
  //       print('Splash page Location ${TemporaryValue.userLat}');
  //
  //       await Future.wait([
  //         sharedPref.saveUserLocation({'Latitude': pos.latitude.toString(), 'Longitude': pos.longitude.toString()}),
  //       ]);
  //     }
  //   } catch (e) {
  //     debugPrint('home_tab page location $e.toString()');
  //   } finally {
  //     debugPrint('home_tab page location get');
  //   }
  // }
}
