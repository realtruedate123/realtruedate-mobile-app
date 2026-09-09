import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/home_tab/controller/home_tab_controller.dart';
import 'package:real_true_date/data/home_tab/view/home_tab_view.dart';
import 'package:real_true_date/data/matches_tab/controller/matches_tab_controller.dart';
import 'package:real_true_date/data/matches_tab/view/matches_tab_view.dart';
import 'package:real_true_date/data/message_tab/view/message_tab_view.dart';
import 'package:real_true_date/data/profile_tab/view/profile_tab_view.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  // late final PersistentTabController controller;
  final rootTabController = Get.find<RootTabController>();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildScreens() {
    // Replace these with your real page widgets (HomePage(), SearchPage(), ProfilePage())
    return [
      HomeTabView(),
      MatchesTabView(),
      MessageTabView(),
      ProfileTabView()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    final theme = AppTheme.of(context);
    return [
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getHomeTabIcon(context, size: 17, iconTintColor: true),
            SizedBox(height: 5), // reduce or remove gap here
            AppTextFont(
              'Home',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: theme.primaryColor,
            )
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getHomeTabIcon(context, size: 20),
            SizedBox(height: 8), // same here
            AppTextFont(
              'Home',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.inactiveTabColor,
            )
          ],
        ),
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: theme.inactiveTabColor,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getMatchesTabIcon(context, size: 24, iconTintColor: true),
            SizedBox(height: 5), // 🔹 reduce or remove gap here
            AppTextFont(
              'Matches',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: theme.primaryColor,
            )
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getMatchesTabIcon(context, size: 24),
            SizedBox(height: 8), // 🔹 same here
            AppTextFont(
              'Matches',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.inactiveTabColor,
            )
          ],
        ),
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: theme.inactiveTabColor,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getMessageTabIcon(context, size: 22, iconTintColor: true),
            SizedBox(height: 5), // 🔹 reduce or remove gap here
            AppTextFont(
              'Message',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: theme.primaryColor,
            )
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getMessageTabIcon(context, size: 24),
            SizedBox(height: 8), // 🔹 same here
            AppTextFont(
              'Message',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.inactiveTabColor,
            )
          ],
        ),
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: theme.inactiveTabColor,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getProfileTabIcon(context, size: 20, iconTintColor: true),
            SizedBox(height: 5), // 🔹 reduce or remove gap here
            AppTextFont(
              'Profile',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: theme.primaryColor,
            )
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.getProfileTabIcon(context, size: 22),
            SizedBox(height: 8), // 🔹 same here
            AppTextFont(
              'Profile',
              font: AppFontType.urbanist,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.inactiveTabColor,
            )
          ],
        ),
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: theme.inactiveTabColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return PersistentTabView(
      context,
      controller: rootTabController.tabController,
      screens: _buildScreens(),
      items: _navBarsItems(context),
      confineToSafeArea: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      animationSettings: NavBarAnimationSettings(
        // control item animation when a nav item is selected
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 0),
          curve: Curves.ease,
        ),
        // control screen transition animation when switching tabs
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: false,
          curve: Curves.ease,
          duration: Duration(milliseconds: 0),
        ),
      ),

      // layout / style options (optional)
      backgroundColor: Colors.white,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: theme.inactiveTabColor.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, -1), // negative Y = top shadow
            spreadRadius: 0,
          ),
        ],
      ),
      navBarHeight: 60,
      // show / hide navBar with animation using Provider or by toggling `isVisible`
      isVisible: true,
      stateManagement: true,
      handleAndroidBackButtonPress: true,
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {
        // Handle the tab click event here
        debugPrint("Tab with index $index was selected!");
        // You can perform actions based on the selected tab,
        // such as updating state, navigating, or calling specific functions.
        // controller.tabController.index = index; // 🔹 This updates the current selected tab
        rootTabController.switchTo(index);
        setState(() {
          debugPrint('select');
        });
        if(index == 0){
          if (Get.isRegistered<HomeTabController>()) {
            final controller = Get.find<HomeTabController>();
            controller.getApiData();
            controller.getFeedListApiCall(); // load initial state
          }
        }
        else if (index == 1) {
          if (Get.isRegistered<MatchesTabController>()) {
            final controller = Get.find<MatchesTabController>();
            controller.getMatchesListApiCall(); // load initial state
          }
        }
      },
    );
  }
}
