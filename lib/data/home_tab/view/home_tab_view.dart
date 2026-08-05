import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/utils/GlobalSkeletonWrapper.dart';
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
            height: MediaQuery.of(context).size.height * 0.68,
            // width: MediaQuery.of(context).size.width - 100,
            child:
            Obx(() {
              // if (controller.isLoading.value) {
              //   return GlobalSkeletonWrapper(type: SkeletonType.home);
              // }

              if (controller.feedListModel.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No profiles available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return AppinioSwiper(
                controller: controller.swiperController,
                cardCount: controller.feedListModel.length,

                // Swipe configuration
                swipeOptions: const SwipeOptions.only(
                  left: true,
                  right: true,
                  up: false,
                  down: false,
                ),

                cardBuilder: (context, index) {
                  final item = controller.feedListModel[index];

                  return ProfileSwipeCard(
                    name: item.firstName,
                    age: item.age,
                    city: [item.city, item.state]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(' '),
                    imageUrl: item.photoUrl ?? '',
                    isVerified: item.isVerified,

                    // Action handlers
                    onCancel: () => controller.swiperController.swipeLeft(),
                    onLike: () => controller.swiperController.swipeRight(),
                    // onFavorites: () => controller.swiperController.swipeUp(),
                    onFavorites: () {
                      debugPrint('Favorites clicked for index: $index');
                      controller.favoritesMatchProfileApiCall(item.userId);
                    },
                    onPhoto: () {
                      debugPrint('Photo clicked for index: $index');
                      Get.toNamed(Routes.userProfileView, arguments: item);
                    },
                  );
                },

                // Optional callbacks
                onSwipeBegin: (previousIndex, targetIndex, activity) {
                  debugPrint('Swipe started: $previousIndex → $targetIndex');
                },

                onSwipeEnd: (previousIndex, targetIndex, activity) {
                  debugPrint('Swipe ended: $previousIndex → $targetIndex');
                  print('activity.direction ${activity.direction}');

                  final item = controller.feedListModel[previousIndex];
                  print('${item.userId} =swip ${activity.direction}= ${item.firstName}');


                  // Optional: Handle like/dislike logic here
                  if (activity.direction == AxisDirection.right) {
                    controller.swipeCardApiCall('right', item);
                  } else if (activity.direction == AxisDirection.left) {
                    controller.swipeCardApiCall('left', item);
                  }
                },

                onEnd: () {
                  debugPrint('No more cards');
                  controller.feedListModel.value = [];
                  // Optional: Load more cards
                  // controller.loadMoreProfiles();
                },
              );
            }),
          ),
        )
          ],
        ),
      ),
    );
  }
}
