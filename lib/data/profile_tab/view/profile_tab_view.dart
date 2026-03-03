import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/forgot_password/forgot_password_controller.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_header.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/profile_tab/controller/profile_tab_controller.dart';
import 'package:real_true_date/data/profile_tab/model/profile_model.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/custom_dialog/confirmation_dialog.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileTabView extends StatelessWidget {
  final controller = Get.put(ProfileTabController());
  ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.whiteColor,
      body: Obx(
            () => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [

              /// Gradient Header
              Container(
                height: 220.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEE9EA9),
                      Color(0xFF5D5494),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
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
                      ),
                      child: Column(
                        children: [

                          SizedBox(height: 30.h),

                          /// Dynamic Sections
                          ...controller.profileSections
                              .map((section) => _buildSection(section, context))
                              .toList(),

                          SizedBox(height: 10.h),

                          Center(
                            child: Text(
                              "Delete Account",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Avatar
                  Obx(() {
                    return Transform.translate(
                      offset: Offset(0, -70.h),
                      child: Column(
                        children: [
                          // CircleAvatar(
                          //   radius: 50.r,
                          //   backgroundColor: Colors.transparent,
                          //   child: AppIcons.getUserPlaceHolder(context, size: 150),
                          //   // child: CircleAvatar(
                          //   //   radius: 50.r,
                          //   //   backgroundImage: const NetworkImage(
                          //   //       'https://i.pravatar.cc/150?img=12'),
                          //   // ),
                          // ),
                          SizedBox(
                            height: 125.h, // Increased height to fit the text
                            width: 125.w,
                            child: Center(
                                child:
                                CachedNetworkImage(
                                  imageUrl: '',
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover, // This is the key for setting it as a cover image
                                      ),
                                    ),
                                  ),
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => AppIcons.getUserPlaceHolder(context, size: 125),
                                )
                            ),
                          ),
                          SizedBox(height: 10.h,),
                          /// Name
                          AppTextFont(
                            controller.userProfile.value.user?.fullName ?? '',
                            font: AppFontType.urbanist,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  })

                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ProfileSection section, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null) ...[
          SizedBox(height: 20.h),
          AppTextFont(
            section.title!,
            font: AppFontType.urbanist,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          SizedBox(height: 20.h),
        ],
        ...section.items.map((item) => _buildMenuItem(item, context)),
      ],
    );
  }

  Widget _buildMenuItem(ProfileMenuItem item, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.w),
      leading: Container(
        padding: EdgeInsets.all(0),
        child: item.icon,
      ),
      title: AppTextFont(
        item.title,
        font: AppFontType.urbanist,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      trailing: AppIcons.getRightArrowIcon(Get.context!),
      // onTap: item.onTap,
      onTap: () {
        print("Tapped ${item.title}");
        _buildMenuItemIndex(item.title, context);
      },
    );
  }

  void _buildMenuItemIndex(String name, BuildContext context) {
      if(name == 'My Profile'){
        Get.toNamed(Routes.editProfileView);
      } else if(name == 'Saved Profiles'){
        Get.toNamed(Routes.savedProfileView);
      } else if(name == 'Change Password'){
        Get.toNamed(Routes.changePassword);
      }
      else if(name == 'Log Out'){
        showDialog(
          context: context,
          barrierColor: Colors.black12.withAlpha(204),
          builder: (context) => ConfirmationDialog(
            title: 'Logout!',
            message: 'Are you sure you want to Logout?',
            onConfirm: () {
              controller.removePreference();
            },
          ),
        );
      }
  }
}
