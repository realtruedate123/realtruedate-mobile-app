import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/data/splash_on_boarding%20/splash_controller.dart';
import 'package:real_true_date/helper/notification_service.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // _initializeAppAndNavigate();
  }

  /*Future<void> _initializeAppAndNavigate() async {
    // 1. Simulate app loading time (Splash animation, Auth check, API calls)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = await SharedPrefHelper().getPersonList();
    if (user?.user?.id?.isNotEmpty ?? false) {
      // 2. Check if the app was launched via a Killed-state notification tap
      if (NotificationService.pendingKilledPayload != null) {
        print('NotificationService pendingKilledPayload');
        // Process notification redirect
        NotificationService.processPendingNotification();
      }
      else {
        // Normal app startup flow (go to Home or Login)
        print('NotificationService Normal app startup flow');
        // Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        // Extract to local variable to enable Dart type promotion
        final videoController = splashController.controller;
        final isInitialized = videoController != null && videoController.value.isInitialized;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppIcons.splashImagePng),
                fit: BoxFit.cover,
              ),
            ),
            child: isInitialized
                ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoController.value.size.width,
                  height: videoController.value.size.height,
                  child: VideoPlayer(videoController),
                ),
              ),
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}