import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_theme.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;

  const ImagePreviewScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
            'Preview',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: const BackButton(color: Colors.white), // sets back button tint
      ),
      body: Column(
        children: [
          // Display captured mirrored photo
          Expanded(
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Retake & Use Photo action buttons
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: Colors.black,
              child: Row(
                children: [
                  // Option 1: Retake (Discard photo and go back)
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          padding: EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () {
                        Get.back(result: null); // Return null to retake
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Option 2: Use Photo (Confirm & pass back file to upload)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () {
                        Get.back(result: imageFile); // Return confirmed file
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Use Photo', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}