import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:real_true_date/data/upload_picture_and_video/widget/custom_camera_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCamera extends StatelessWidget {
  final controller = Get.put(CustomCameraController());

  CustomCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [

            /// 🎨 BACKGROUND
            Positioned.fill(
              child: Container(color: Colors.black),
            ),

            /// 📷 CAMERA / IMAGE PREVIEW
            Positioned.fill(
              child: Obx(() {

                /// 📸 AFTER CAPTURED → Show Image
                if (controller.capturedImage.value != null) {
                  return Center(
                    child: Image.file(
                      File(controller.capturedImage.value!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }

                // Camera preview
                return Center(
                  child: AspectRatio(
                    aspectRatio: 0.57,
                    child: CameraPreview(controller.cameraController),
                  ),
                );
              }),
            ),

            /// ❌ CLOSE BUTTON
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Get.back(),
              ),
            ),

            /// 🔄 SWITCH CAMERA BUTTON
            Positioned(
              top: 40.h,
              left: 20.w,
              child: IconButton(
                icon: const Icon(Icons.cameraswitch, color: Colors.white),
                onPressed: () => controller.switchCameraForPhoto(),
              ),
            ),

            /// 🔘 CAPTURE / RETAKE / USE BUTTONS
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(() {

                  /// AFTER CAPTURE
                  if (controller.capturedImage.value != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        /// 🔁 RETAKE
                        TextButton(
                          onPressed: controller.retakePhoto,
                          child: const Text(
                            'Retake',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        const Spacer(),

                        /// ✅ USE PHOTO
                        TextButton(
                          onPressed: () {
                            final file = controller.capturedImage.value!;
                            Get.back(result: file);
                          },
                          child: const Text(
                            'Use Photo',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }

                  /// 📸 CAPTURE BUTTON
                  return GestureDetector(
                    onTap: controller.takePhoto,
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}