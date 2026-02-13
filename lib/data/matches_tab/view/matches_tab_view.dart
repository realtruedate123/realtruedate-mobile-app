import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/matches_tab/controller/matches_tab_controller.dart';
import 'package:real_true_date/data/matches_tab/widget/match_card_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_true_date/helper/appbar_wrapper/match_appbar_wrapper.dart';
import 'package:real_true_date/routes/routes.dart';

class MatchesTabView extends StatelessWidget {
  final controller = Get.put(MatchesTabController());
  MatchesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.whiteColor,
      appBar: MatchAppbarWrapper(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Your Matches ",
                      style: GoogleFonts.urbanist(
                        color: theme.blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),
                    ),
                    TextSpan(
                      text: "52",
                      style: GoogleFonts.urbanist(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemCount: controller.matches.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 5.h,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, index) {
                    return MatchCardListCell(
                      match: controller.matches[index],
                      onTap: () {
                        Get.toNamed(
                          Routes.matchesDetailsView,
                        );
                      },
                    );
                  },
                )

              ),
            ],
          ),
        ),
      ),
    );
  }
}
