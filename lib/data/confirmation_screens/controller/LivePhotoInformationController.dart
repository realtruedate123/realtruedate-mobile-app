import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:real_true_date/data/confirmation_screens/model/info_step_model.dart';
import 'package:real_true_date/helper/bottom_nav_wrapper.dart';
import 'package:real_true_date/routes/routes.dart';

class LivePhotoInformationController extends GetxController {
  late final int initialIndex = Get.arguments['initialIndex'];
  // LivePhotoInformationController({this.initialIndex = 0});

  // Change from int to RxInt
  var currentIndex = 0.obs;

  final List<InfoStepModel> steps = [
    InfoStepModel(
      title: "Next: Pick Your Dream Dates",
      description: "Pick the 2 partner types you are most attracted to.",
      buttonText: "Continue",
      icon: Icons.info,
    ),
    InfoStepModel(
      title: "Dream Dates Saved",
      description: "Your preferences are saved. Our AI will now begin finding your closest matches.",
      buttonText: "Continue",
      icon: Icons.info,
    ),
    InfoStepModel(
      title: "Next: Verify Your Profile",
      description: "Upload 2 live photos and 1 short live video. \n\n Video: Slowly turn your head left and right and open mouth. \n\n Image: Look straight at the camera.\nRemove hats and sunglasses. Use good lighting.",
      buttonText: "Start Verification",
      icon: Icons.info,
    ),

    InfoStepModel(
      title: "You Are Verified",
      description: "Your profile is now confirmed as real.\n\n Your Dream Date selections are saved and your profile is verified. \n\n Real True Date artifical intelligence will now start sending you Dream Dates to interact with Enjoy yourself and date responsibly.",
      buttonText: "Go to Feed",
      icon: Icons.info,
    ),
  ];

  InfoStepModel get currentStep => steps[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = initialIndex; // set the initial step
  }

    void nextStep() {
    if (currentIndex < steps.length - 1) {
      print('currentIndex $currentIndex');

      if(currentIndex.value == 0){
        currentIndex.value += 1;
        Get.toNamed(
          Routes.selectDreamPartnerView,
        );
      }
      else if(currentIndex.value == 1){
        currentIndex.value += 1;

      } else if(currentIndex.value == 2){
        currentIndex.value += 1;
        Get.toNamed(
          Routes.uploadVideoPage,
        );
      }
      update();
    } else {
      // Final navigation
      // Get.offAllNamed('/home');
      print('final currentIndex $currentIndex');
      Get.offAll(() => BottomNavWrapper());
    }
  }
}