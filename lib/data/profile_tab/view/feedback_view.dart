import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/profile_tab/controller/feedback_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final List<Map<String, dynamic>> ratingOptions = [
      {'label': 'Worst', 'emoji': '😖'},
      {'label': 'Not\nGood', 'emoji': '🙁'},
      {'label': 'Fine', 'emoji': '😐'},
      {'label': 'Look\nGood', 'emoji': '😀'},
      {'label': 'Very\nGood', 'emoji': '😍'},
    ];

    return Scaffold(
      appBar: TransparentBackAppBar(
        title: 'Feedback',
        titleStyle: TextStyle(
          fontFamily: AppFontType.urbanist.toString(),
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppIcons.headerImagePng),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.containerBG,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                        child: Column(
                          children: [
                            SizedBox(height: 30.h),
                            // 1. Name Input
                            AuthInput(
                              hint: 'Name',
                              controller: controller.nameController,
                              icon: AppIcons.getPeopleIcon(context),
                            ),
                            SizedBox(height: 5.h),
        
                            // 2. Email Address Input
                            AuthInput(
                              hint: 'Email Address',
                              controller: controller.emailController,
                              icon: AppIcons.getEmailIcon(context),
                              keyboardType: TextInputType.emailAddress,
                              enabled: false,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Email required';
                                if (!GetUtils.isEmail(v)) return 'Invalid email address';
                                return null;
                              },
                            ),

                            SizedBox(height: 16.h),
        
                            // 3. Emoji Rating Card
                            Container(
                              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Emojis Row
                                  Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(ratingOptions.length, (index) {
                                      final isSelected =
                                      (controller.ratingValue.value.round() == index);
                                      final option = ratingOptions[index];
        
                                      return Expanded(
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () => controller.setRating(index.toDouble()),
                                          child: Column(
                                            children: [
                                              // Greyscale filter applied when NOT selected
                                              ColorFiltered(
                                                colorFilter: isSelected
                                                    ? const ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.multiply,
                                                )
                                                    : const ColorFilter.matrix(<double>[
                                                  0.2126, 0.7152, 0.0722, 0, 0,
                                                  0.2126, 0.7152, 0.0722, 0, 0,
                                                  0.2126, 0.7152, 0.0722, 0, 0,
                                                  0,      0,      0,      1, 0,
                                                ]),
                                                child: Text(
                                                  option['emoji'],
                                                  style: TextStyle(fontSize: 32.sp),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Text(
                                                option['label'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  color: isSelected
                                                      ? const Color(0xFF1E8881)
                                                      : Colors.grey.shade400,
                                                  height: 1.1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  )),
                                  SizedBox(height: 12.h),
        
                                  // Rating Slider
                                  Obx(
                                        () => SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 10.h,
                                        activeTrackColor: theme.primaryColor,
                                        inactiveTrackColor: theme.primaryColor.withOpacity(0.2),
                                        thumbColor: const Color(0xFFEE8A9C),
                                        overlayColor: Colors.transparent,
                                        // 1. Set track shape
                                        trackShape: const RoundedRectSliderTrackShape(),
                                        // 2. Hide the division dots/ticks along the slider
                                        tickMarkShape: SliderTickMarkShape.noTickMark,
                                        // 3. Custom thumb with pink color and border
                                        thumbShape: CustomBorderSliderThumbShape(
                                          enabledThumbRadius: 12.r,
                                          fillColor: const Color(0xFFEE8A9C),
                                          borderColor: theme.primaryColor,
                                          borderWidth: 3.w,
                                        ),
                                      ),
                                      child: Slider(
                                        value: controller.ratingValue.value,
                                        min: 0.0,
                                        max: 4.0,
                                        divisions: 4,
                                        onChanged: (value) => controller.setRating(value),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
        
                            // 4. Description Text Box
                            Container(
                              height: 180.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: controller.descriptionController,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: 'Write the Description',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15.sp,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
        
                            // 5. Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: Obx(
                                    () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26.r),
                                    ),
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () => controller.submitFeedback(),
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                    height: 20.h,
                                    width: 20.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: MediaQuery.textScalerOf(context).scale(16),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}

class CustomBorderSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;

  const CustomBorderSliderThumbShape({
    required this.enabledThumbRadius,
    required this.fillColor,
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Draw Fill Paint (Pink Circle)
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Draw Border Paint (White Ring)
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, enabledThumbRadius, fillPaint);
    canvas.drawCircle(center, enabledThumbRadius - (borderWidth / 2), borderPaint);
  }
}