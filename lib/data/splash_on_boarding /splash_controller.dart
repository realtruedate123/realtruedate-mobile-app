import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:real_true_date/helper/bottom_nav_wrapper.dart';
import 'package:real_true_date/helper/location_service.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:video_player/video_player.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final sharedPref = SharedPrefHelper();
  late VideoPlayerController controller;

  @override
  void onInit() {
    super.onInit();

    initializeVideo();

    fetchCurrentLocation();

    /// Navigate after delay
    // Future.delayed(const Duration(seconds: 2), () async {
      // checkLogin();

      /*final user = await sharedPref.getPersonList();

      if (user != null && user.user?.id != null && user.user?.id != '') {
        print('user ID ${user.user?.id}');
        // print('user ID ${user.user?.toJson()}');

        // User is logged in
        Get.offAll(() => BottomNavWrapper());
      } else {
        // User not logged in -> go to onboarding
        Get.offAllNamed(Routes.onBoarding);
      }*/
    // });
  }

  Future<void> initializeVideo() async {
    controller = VideoPlayerController.asset(
      'assets/video/splash_video.mp4',
    );

    await controller.initialize();

    controller.setLooping(false);

    controller.addListener(() {
      if (controller.value.isInitialized &&
          controller.value.position >= controller.value.duration) {
        print("Video finished!");
        checkLogin();
      }
    });

    await controller.play();

    update();
  }

  Future<void> checkLogin() async {
    try {
      print("Checking login...");

      final user = await sharedPref.getPersonList();

      print("User fetched: $user");

      if (user?.user?.id?.isNotEmpty ?? false) {
        print('user ID ${user?.user?.id}');
        Get.offAll(() => BottomNavWrapper());
      } else {
        Get.offAllNamed(Routes.onBoarding);
      }
    } catch (e) {
      print("Splash error: $e");
      Get.offAllNamed(Routes.onBoarding);
    }
  }

  /// Fetch current location once
  Future<void> fetchCurrentLocation() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      if (pos != null) {
        print('Splash page Location $pos');

        AppState.instance.userLat = pos.latitude;
        AppState.instance.userLong = pos.longitude;

        print('Splash page Location ${AppState.instance.userLat}');

        await Future.wait([
          sharedPref.saveUserLocation({'Latitude': pos.latitude.toString(), 'Longitude': pos.longitude.toString()}),
        ]);
      }
    } catch (e) {
      debugPrint('home_tab page location $e.toString()');
    } finally {
      debugPrint('home_tab page location get');
    }
  }
}
