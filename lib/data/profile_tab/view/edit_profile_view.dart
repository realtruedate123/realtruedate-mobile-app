import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/input_container.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/profile_tab/controller/edit_profile_controller.dart';
import 'package:real_true_date/data/profile_tab/model/profile_model.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/gender_toggle.dart';
import 'package:real_true_date/helper/interest_selection_widget.dart';

class EditProfileView extends StatelessWidget {
  final controller = Get.put(EditProfileController());

  EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: theme.whiteColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// Gradient Header
              Stack(
                children: [
                  /// Gradient background
                  Container(
                    height: 250.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: const [Color(0xFFEE9EA9), Color(0xFF5D5494)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
      
                  /// Custom header (on top of gradient)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16.h,
                        left: 16.w,
                        right: 16.w,
                        bottom: 16.h,
                      ),
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// Title in center
                          Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFontType.urbanist.toString(),
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
      
                          /// Back button aligned left
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: AppIcons.getBackOutLineIcon(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      
              /// Content Card + Avatar
              Transform.translate(
                offset: Offset(0, -25.h),
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.w, 70.h, 20.w, 30.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, -2),
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 5.h),
      
                                /// Name
                                AuthInput(
                                  hint: 'Name',
                                  controller: controller.nameCtrl,
                                  icon: AppIcons.getPeopleIcon(context),
                                ),
                                SizedBox(height: 5.h),
      
                                /// DOB picker
                                InputContainer(
                                  height: 58.h,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () => showDobPicker(context, controller),
                                    child: Obx(
                                          () => Row(
                                        children: [
                                          AppIcons.getBirthdayIcon(
                                            context,
                                            color: controller.dob.value == null
                                                ? theme.iconTintColor
                                                : theme.primaryColor,
                                          ),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            child: Text(
                                              controller.dob.value == null
                                                  ? 'When your Birthday?'
                                                  : DateFormat('yyyy-MM-dd').format(
                                                controller.dob.value!,
                                              ),
                                              style: TextStyle(
                                                fontSize: MediaQuery.textScalerOf(context).scale(15),
                                                color: controller.dob.value == null
                                                    ? theme.iconTintColor
                                                    : theme.primaryColor,
                                              ),
                                            ),
                                          ),
                                          AppIcons.getCalendarIcon(context),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
      
                                SizedBox(height: 25.h),
      
                                /// email
                                AuthInput(
                                  hint: 'Email Address',
                                  controller: controller.emailCtrl,
                                  icon: AppIcons.getEmailIcon(context),
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: false,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Email required';
                                    if (!GetUtils.isEmail(v)) return 'Invalid email address';
                                    return null;
                                  },
                                ),
      
                                SizedBox(height: 5.h),
                                /// Interest Selection
                            Obx(() => InterestSelectionWidget(
                              interests: [
                                'Nature',
                                'Travel',
                                'Writing',
                              ],
                              initialSelected: controller.interests.toList(),
                              onChanged: (selectedList) {
                                print('Selected Interests: $selectedList');
                                controller.selectedInterests = selectedList;
                              },
                            ),
                            ),
      
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    AppTextFont(
                                      'Select your gender',
                                      font: AppFontType.inter,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: theme.primaryColor,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                SizedBox(height: 5.h),
      
                                GenderToggle(controller: controller),
      
                                SizedBox(height: 25.h),
      
                                /// Bio TextField
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: controller.bioController, // <--- Attach it here
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText: "Write Short bio",
                                      hintStyle: TextStyle(
                                        color: theme.iconTintColor,
                                        fontSize: MediaQuery.textScalerOf(context).scale(15),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontFamily: AppFontType.lato.toString(),
                                      fontSize: 16,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
      
                                SizedBox(height: 25.h),
      
                                PrimaryButton(
                                  title: 'Update Profile',
                                  onTap: () {
                                    controller.updateProfileApiCall();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
      
                    /// Avatar - Fixed: Removed nested Obx
                    Positioned(
                      top: -70.h,
                      child: Obx(() {
                        final hasLocalAvatar = controller.avatarPath.value.isNotEmpty;
                        final hasNetworkAvatar = controller.profileUrl.value.isNotEmpty;
                        final double avatarSize = 125.r; // Fixed diameter for all states
      
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            /// Avatar Container
                            ClipOval(
                              child: SizedBox(
                                width: avatarSize,
                                height: avatarSize,
                                child: () {
                                  // 1. Selected from gallery
                                  if (hasLocalAvatar) {
                                    return Image.file(
                                      File(controller.avatarPath.value),
                                      fit: BoxFit.cover,
                                      width: avatarSize,
                                      height: avatarSize,
                                      errorBuilder: (context, error, stackTrace) =>
                                          AppIcons.getUserPlaceHolder(context, size: avatarSize),
                                    );
                                  }
      
                                  // 2. Loaded from URL
                                  if (hasNetworkAvatar) {
                                    return AppCachedImage(
                                      imageUrl: controller.profileUrl.value,
                                      height: avatarSize,
                                      width: avatarSize,
                                      fit: BoxFit.cover,
                                    );
                                  }
      
                                  // 3. Fallback placeholder
                                  return AppIcons.getUserPlaceHolder(context, size: avatarSize);
                                }(),
                              ),
                            ),
      
                            /// Edit Button
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () => controller.showImagePickerOptions(context),
                                child: AppIcons.getEditProfileIcon(
                                  context,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showGenderPicker(
      BuildContext context,
      EditProfileController controller,
      ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Male', 'Female'].map((e) {
              return ListTile(
                title: Text(e),
                onTap: () {
                  controller.setLookingGender(e);
                  Get.back();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void showDobPicker(BuildContext context, EditProfileController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag handle
              SizedBox(height: 5.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 12.h),

              /// Header with Close
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 48.w),
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 200.h,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: controller.dob.value ?? DateTime(2000),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: controller.setDob,
                ),
              ),

              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(ProfileMenuItem item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.w),
      leading: Container(padding: EdgeInsets.zero, child: item.icon),
      title: AppTextFont(
        item.title,
        font: AppFontType.urbanist,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      trailing: AppIcons.getRightArrowIcon(Get.context!),
      onTap: item.onTap,
    );
  }
}