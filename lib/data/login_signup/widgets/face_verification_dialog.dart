import 'package:flutter/material.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';

void showFaceVerificationDialog(BuildContext context, {required VoidCallback onAgreeAndContinue}) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must make a choice
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        title: Row(
          children: [
            Icon(
              Icons.verified_user_rounded,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Face Verification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'To help keep Real True Date safe and verify that your profile belongs to a real person, we need to process a short verification video of your face and your profile photos.\n\n'
                      'Your verification video and profile photos will be securely uploaded to and processed on our servers using our face-verification technology. We use this information to perform liveness checks and compare your face in the verification video with your profile photos.\n\n'
                      'Your face-verification data and profile photos are not sold or used for advertising or marketing and are not shared with third-party AI providers.\n\n'
                      'We process this information only for identity and profile verification, fraud prevention, and platform safety, as described in our Privacy Policy.',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 16),
                const Text(
                  'By tapping “I Agree & Continue,” you consent to the collection and processing of your face-verification data for these purposes.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(
                title: 'I Agree & Continue',
                fontWeight: FontWeight.w600,
                onTap: (){
                  Navigator.of(context).pop(); // Close dialog
                  onAgreeAndContinue(); // Trigger your camera/verification logic
                }
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cancel/Close
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}