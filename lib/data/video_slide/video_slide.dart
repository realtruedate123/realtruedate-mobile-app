import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:video_player/video_player.dart';

class VideoSlide extends StatefulWidget {
  final String genderType;

  const VideoSlide({super.key, required this.genderType});

  @override
  State<VideoSlide> createState() => _VideoSlideState();
}

class _VideoSlideState extends State<VideoSlide> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      widget.genderType.toLowerCase() != 'm' ? 'assets/video/male_video.mp4' : 'assets/video/female_video.mp4',
    )..initialize().then((_) {
      setState(() {});
      _controller.play();
      _controller.setLooping(false);
    });
  }

  @override
  void dispose() {
    _controller.pause(); // 👈 Ensure video stops playing on dispose
    _controller.dispose();
    super.dispose();
  }

  /// Open next step info page
  void _onGoNext() {
    // 👈 1. Stop video playback immediately
    if (_controller.value.isPlaying) {
      _controller.pause();
    }

    // 👈 2. Navigate to next screen
    Get.toNamed(Routes.confirmationInfo, arguments: {
      'initialIndex': 0,
    })?.then((_) {
      // Optional: resume video if the user returns back to this screen
      // if (mounted && !_controller.value.isPlaying) {
      //   _controller.play();
      // }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disables the swipe gesture and back button
      child: Scaffold(
        body: Stack(
          children: [
            /// 🔹 Fullscreen Video
            _controller.value.isInitialized
                ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
                : const Center(child: CircularProgressIndicator()),

            // Skip button
            Positioned(
              right: 10,
              child: GestureDetector(
                onTap: _onGoNext,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white30,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Go Next",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
