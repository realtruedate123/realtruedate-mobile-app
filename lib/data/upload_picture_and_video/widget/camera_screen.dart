import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:video_player/video_player.dart';
import 'camera_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraScreen extends StatelessWidget {
  final controller = Get.put(CameraViewController());

  CameraScreen({super.key});

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

            /// 📷 CAMERA / VIDEO PREVIEW
            Positioned.fill(
              child: Obx(() {
                // Video preview
                if (controller.recordedFile.value != null &&
                    controller.videoController.value != null &&
                    controller.videoController.value!.value.isInitialized) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio:
                        controller.videoController.value!.value.aspectRatio,
                        child: VideoPlayer(controller.videoController.value!),
                      ),

                      /// Play/Pause button overlay
                      Obx(() => controller.isVideoPlaying.value
                          ? const SizedBox.shrink()
                          : GestureDetector(
                        onTap: controller.toggleVideoPlayPause,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black45,
                          ),
                          padding: EdgeInsets.all(16),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      )),
                    ],
                  );
                }

                // Camera preview
                return Center(
                  child: AspectRatio(
                    aspectRatio: 0.55,
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
                icon: Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Get.back(),
              ),
            ),

            /// 🔄 SWITCH CAMERA BUTTON
            Positioned(
              top: 40.h,
              left: 20.w,
              child: IconButton(
                icon: const Icon(Icons.cameraswitch, color: Colors.white),
                onPressed: () => controller.switchCamera(),
              ),
            ),

            /// ⏳ COUNTDOWN TIMER
            Positioned(
              top: 40.h,
              left: 0,
              right: 0,
              child: Obx(() => controller.isRecording.value
                  ? Text(
                "${controller.countdown.value}s",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  : const SizedBox()),
            ),
            /// 🔴 RECORD / RETAKE / USE BUTTONS
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(() {
                  // AFTER RECORDING
                  if (controller.recordedFile.value != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// 🔁 RETAKE
                        TextButton(
                          onPressed: controller.retake,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: AppTextFont(
                            'Retake',
                            font: AppFontType.urbanist,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Spacer(),

                        /// ✅ USE
                        TextButton(
                          onPressed: () {
                            final file = controller.recordedFile.value!;
                            Get.back(result: {
                              "file": file,
                              "session_id": controller.sessionID,
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: AppTextFont(
                            'Use Video',
                            font: AppFontType.urbanist,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }

                  /// 🎥 RECORD BUTTON
                  return GestureDetector(
                    onTap: () {
                      if (controller.isRecording.value) {
                        controller.stopRecording();
                      } else {
                        controller.startRecordingWithTimer(20, controller.randomTexts);
                      }
                    },
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isRecording.value
                            ? Colors.red
                            : Colors.white,
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