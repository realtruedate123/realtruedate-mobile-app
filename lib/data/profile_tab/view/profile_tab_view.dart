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
      backgroundColor: Colors.white,
      // Remove default AppBar background
      extendBodyBehindAppBar: true,
      appBar: TransparentBackAppBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            /// Header Title View
            Center(
              child: Text('Under development'),
            )
          ],
        ),
      ),
    );
  }
}
