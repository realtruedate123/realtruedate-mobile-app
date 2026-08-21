import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:real_true_date/helper/bottom_nav_wrapper.dart';
import 'package:real_true_date/helper/location_service.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:video_player/video_player.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final sharedPref = SharedPrefHelper();

  // 1. Make it nullable instead of late
  VideoPlayerController? controller;
  bool _hasNavigated = false;
  bool isKillMode = false;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  void setKillMode(bool value) {
    isKillMode = value;
    print('isKillMode $isKillMode');
    if(isKillMode) {
      _hasNavigated = true;
      checkLogin();
    } else {
      initializeVideo();
    }
    update();
  }

  Future<void> initializeVideo() async {
    try {
      final videoController = VideoPlayerController.asset('assets/video/splash_video.mp4');

      // Initialize local instance first
      await videoController.initialize();
      videoController.setLooping(false);

      // Assign to class field ONLY after initialization finishes
      controller = videoController;

      controller?.addListener(() {
        if (!_hasNavigated && (controller?.value.isInitialized ?? false)) {
          final position = controller!.value.position;
          final duration = controller!.value.duration;

          if (position >= duration || (duration - position).inMilliseconds < 100) {
            print("Video finished!");
            _hasNavigated = true;
            checkLogin();
          }
        }
      });

      await controller?.play();
      update(); // Rebuild UI when video is initialized and playing

      // Fallback timer
      final videoDuration = controller?.value.duration ?? const Duration(seconds: 3);
      Future.delayed(videoDuration + const Duration(seconds: 1), () {
        if (!_hasNavigated) {
          _hasNavigated = true;
          checkLogin();
        }
      });

    } catch (e) {
      print("Error initializing video: $e");
      if (!_hasNavigated) {
        _hasNavigated = true;
        checkLogin();
      }
    }
  }

  Future<void> checkLogin() async {
    try {
      final user = await sharedPref.getPersonList();
      if (user?.user?.id?.isNotEmpty ?? false) {
        Get.offAll(() => BottomNavWrapper());
      } else {
        Get.offAllNamed(Routes.onBoarding);
      }
    } catch (e) {
      Get.offAllNamed(Routes.onBoarding);
    }
  }

  /// Fetch current location once
  Future<void> fetchCurrentLocation() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      if (pos != null) {
        print('Location $pos');

        AppState.instance.userLat = pos.latitude;
        AppState.instance.userLong = pos.longitude;

        print('Location ${AppState.instance.userLat}');

        await Future.wait([
          sharedPref.saveUserLocation({'Latitude': pos.latitude.toString(), 'Longitude': pos.longitude.toString()}),
        ]);
      }
    } catch (e) {
      debugPrint('location $e.toString()');
    } finally {
      debugPrint('location get');
    }
  }

  @override
  void onClose() {
    // controller?.dispose();
    super.onClose();
  }
}