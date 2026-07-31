import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'camera_controller.dart';
import 'image_preview_screen.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomCameraController controller = Get.put(CustomCameraController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Take Photo',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white), // sets back button tint
      ),
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Live Camera Viewport
            Center(
              child: CameraPreview(controller.cameraController!),
            ),

            // Shutter Button & Progress Indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  if (controller.isCapturing.value)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  else
                    GestureDetector(
                      onTap: () async {
                        File? mirroredFile = await controller.captureAndMirrorImage();

                        if (mirroredFile != null) {
                          // Navigate to Preview Screen
                          final File? confirmedFile = await Get.to<File?>(
                                () => ImagePreviewScreen(imageFile: mirroredFile),
                          );

                          // If user tapped "Use Photo", return file to main flow
                          if (confirmedFile != null) {
                            Get.back(result: confirmedFile);
                          }
                        }
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          color: Colors.white24,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}