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
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';
import 'package:real_true_date/routes/routes.dart';

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
                height: 300.h,
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
                offset: Offset(0, -100.h),
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
                          /// Name
                          AppTextFont(
                            'Ganesha Kencana',
                            font: AppFontType.urbanist,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 20.h),

                          /// Dynamic Sections
                          ...controller.profileSections
                              .map((section) => _buildSection(section))
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
                    Transform.translate(
                      offset: Offset(0, -70.h),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.transparent,
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?img=12'),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ProfileSection section) {
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
        ...section.items.map((item) => _buildMenuItem(item)),
      ],
    );
  }

  Widget _buildMenuItem(ProfileMenuItem item) {
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
      onTap: item.onTap,
    );
  }
}
