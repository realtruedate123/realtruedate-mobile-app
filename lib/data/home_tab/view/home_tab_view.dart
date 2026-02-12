import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/data/home_tab/controller/home_tab_controller.dart';
import 'package:real_true_date/data/home_tab/swipe_card/profile_swipe_card.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/appbar_wrapper/home_appbar_wrapper.dart';
import 'package:real_true_date/routes/routes.dart';

class HomeTabView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HomeAppbarWrapper(),
        CupertinoPageScaffold(
          backgroundColor: CupertinoColors.white,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            // width: MediaQuery.of(context).size.width - 100,
            child: AppinioSwiper(
              controller: controller.swiperController,
              cardCount: 10,
              cardBuilder: (BuildContext context, int index) {
                return ProfileSwipeCard(
                  onCancel: () {
                    controller.swiperController.swipeLeft();
                  },
                  onLike: () {
                    controller.swiperController.swipeRight();
                  },
                  onFavorites: () {
                    controller.swiperController.swipeUp();
                  },
                  onPhoto: () {
                    print('click photo');
                    Get.toNamed(
                        Routes.userProfileView,
                    );
                  },
                );
              },

              onSwipeBegin: (previousIndex, targetIndex, activity) {
                print('Swipe started from $previousIndex to $targetIndex');
              },

              onSwipeEnd: (previousIndex, targetIndex, activity) {
                print('Swipe ended from $previousIndex to $targetIndex');
              },

              onSwipeCancelled: (activity) {
                print('Swipe was cancelled');
              },

              onCardPositionChanged: (position) {
                print('Card pos: $position');
              },

              onEnd: () {
                print('No more cards');
              },
            ),
          ),
        )
          ],
        ),
      ),
    );
  }
}
