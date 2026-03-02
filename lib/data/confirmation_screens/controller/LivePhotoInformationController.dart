import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/data/confirmation_screens/model/info_step_model.dart';
import 'package:real_true_date/helper/bottom_nav_wrapper.dart';
import 'package:real_true_date/routes/routes.dart';

class LivePhotoInformationController extends GetxController {
  late final int initialIndex = Get.arguments['initialIndex'];
  // LivePhotoInformationController({this.initialIndex = 0});

  late var currentIndex = 0;

  final List<InfoStepModel> steps = [
    InfoStepModel(
      title: "Great. Next Step: Live Photo Verification.",
      description: "We require 2 live photos and 1 short live video. This keeps the platform 100% real.",
      buttonText: "Start Verification",
      icon: Icons.info,
    ),
    InfoStepModel(
      title: "Verification Complete.",
      description: "Final Step: Build Your Ideal Partner.",
      buttonText: "Continue",
      icon: Icons.info,
    ),
    InfoStepModel(
      title: "You're Fully Registered.",
      description: "Our AI engine is now searching for your ideal partner. Matches will begin appearing immediately.",
      buttonText: "Go to Feed",
      icon: Icons.info,
    ),
  ];

  InfoStepModel get currentStep => steps[currentIndex];

  @override
  void onInit() {
    super.onInit();
    currentIndex = initialIndex; // set the initial step
  }

  void nextStep() {
    if (currentIndex < steps.length - 1) {
      print('currentIndex $currentIndex');

      if(currentIndex == 0){
        Get.toNamed(
          Routes.uploadVideoPage,
        );
      }
      else if(currentIndex == 1){
        Get.toNamed(Routes.selectDreamPartnerView,);
      }
      currentIndex++;
    } else {
      // Final navigation
      // Get.offAllNamed('/home');
      print('final currentIndex $currentIndex');
      Get.offAll(() => BottomNavWrapper());
    }
  }
}