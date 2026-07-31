import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/select_dream_partner/controller/SelectDreamPartnerController.dart';
import 'package:real_true_date/data/select_dream_partner/model/dream_date_response_model.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';


// VIEW
class SelectDreamPartnerView extends StatelessWidget {
  const SelectDreamPartnerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final controller = Get.put(SelectDreamPartnerController());

    return Scaffold(
      backgroundColor: theme.whiteColor,
      extendBodyBehindAppBar: true,
      appBar: TransparentBackAppBar(backHide: true,),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text(
      //     'Select Dream Partner',
      //     style: TextStyle(
      //       fontFamily: AppFontType.urbanist.toString(),
      //       fontSize: 22,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   leading: Container(),
      //   // leading: IconButton(
      //   //   icon: AppIcons.getBackButtonIcon(context, size: 30),
      //   //   onPressed: () => Navigator.pop(context),
      //   // ),
      // ),
      body: GetBuilder<SelectDreamPartnerController>(
        builder: (SelectDreamPartnerController controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(), // prevents bouncing/overscroll
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // 🔥 KEY FIX
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// HEADER IMAGE
                      SizedBox(
                        height: 270.h, // fixed header height
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            /// HEADER IMAGE
                            Image.asset(
                              AppIcons.headerHalfImagePng,
                              fit: BoxFit.cover,
                            ),

                            /// HEADER TEXT
                            SafeArea(
                              top: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 40.h,),
                                    AppTextFont(
                                      'Select Dream Partner',
                                      font: AppFontType.manrope,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: theme.headerTitleColor,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.h,),
                                    AppTextFont(
                                      'Tap 2 looks you are attracted to. You can change your selection before saving.',
                                      font: AppFontType.manrope,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: theme.lightBlackColor,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.h,),
                                    AppTextFont(
                                      'Step 2 of 3 – Build Your Partner visual selection flow',
                                      font: AppFontType.manrope,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: theme.headerTitleColor,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.h,)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h,),

                      /// WHITE CARD
                      Transform.translate(
                        offset: Offset(0, -60), // 👈 overlap amount
                        child: Container(
                          padding: EdgeInsets.only(left: 16.w, right: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(() {
                                if (controller.isLoading.value) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height - 300,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (controller.catalogListModel.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 12.h),
                                    child: Text(
                                      'Not Partners available',
                                      style: TextStyle(
                                        color: theme.alert,
                                        fontSize: 14.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return GridView.builder(
                                  padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.catalogListModel.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 17,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.60,
                                  ),
                                  itemBuilder: (context, index) {
                                    return _imageTile(context, index, controller);
                                  },
                                );

                              }),

                              // SizedBox(height: 50.h),
                              /// Error message
                              /*Obx(() => controller.errorMessage.isEmpty
                                ? const SizedBox()
                                : Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  color: theme.alert,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),*/

                              // SizedBox(height: 20.h),
                              // Obx(() => SafeArea(child: _uploadButton())),
                              // SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),

                      /// Loader Overlay
                      // Obx(() {
                      //   return controller.isLoading.value
                      //       ? Container(
                      //     color: Colors.black.withOpacity(0.4),
                      //     child: Center(
                      //       child: Stack(
                      //         children: [
                      //           GifLoaderView(isLoading: controller.isLoading.value),
                      //         ],
                      //       )
                      //     ),
                      //   )
                      //       : const SizedBox();
                      // }),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      /// PINNED BUTTON HERE
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Obx(() {
          return PrimaryButton(
            title: 'Submit',
            loading: controller.isLoading.value,
            fontWeight: FontWeight.w600,
            onTap: controller.isSubmitButtonEnable
                ? () {
              debugPrint("controller.selectedCatalogListModel.toString");
              controller.submitSelectedCatalogs();
            } : null,
          );
        })
      ),

        /*
      body: GetBuilder<SelectDreamPartnerController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  AppTextFont(
                    'Tap 2 looks you are attracted to. You can change your selection before saving.',
                    font: AppFontType.manrope,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.lightBlackColor,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h,),
                  AppTextFont(
                    'Step 2 of 3 – Build Your Partner visual selection flow',
                    font: AppFontType.manrope,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.headerTitleColor,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h,),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.catalogListModel.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 17,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.55,
                      ),
                      itemBuilder: (context, index) {
                        return _imageTile(context, index, controller);
                      },
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  PrimaryButton(
                    title: 'Submit',
                    loading: controller.isLoading.value,
                    fontWeight: FontWeight.w600,
                    onTap: controller.isSubmitButtonEnable
                        ? () {
                      debugPrint("controller.selectedCatalogListModel.toString");
                      controller.submitSelectedCatalogs();
                    } : null,
                  )
                ],
              ),
            ),
          );
        },
      ),
      */
    );
  }

  Widget _imageTile(BuildContext context, int index,
      SelectDreamPartnerController controller) {
    final item = controller.catalogListModel[index];
    final isSelected = controller.isSelected(item);

    return GestureDetector(
      onTap: () {
        openBigImageSlider(context, controller, index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected ? AppTheme.of(context).primaryColor : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.18 : 0.08),
              blurRadius: isSelected ? 25 : 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                scale: isSelected ? 1.05 : 1.0,
                child: AppCachedImage(
                  imageUrl: item.imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            // DARK OVERLAY WHEN SELECTED
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 0.15 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
            ),

            // Selection Button
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  controller.toggleSelection(item);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? Colors.green
                        : Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class BigImageSliderPopup extends StatefulWidget {
//   final List<DreamDateItem> catalogList;
//   final int initialIndex;
//   final SelectDreamPartnerController controller;
//
//   const BigImageSliderPopup({
//     super.key,
//     required this.catalogList,
//     required this.initialIndex,
//     required this.controller,
//   });
//
//   @override
//   State<BigImageSliderPopup> createState() => _BigImageSliderPopupState();
// }
//
// class _BigImageSliderPopupState extends State<BigImageSliderPopup>
//     with SingleTickerProviderStateMixin {
//   late PageController pageController;
//   late int currentIndex;
//   late AnimationController animationController;
//   late Animation<double> scaleAnimation;
//   late Animation<double> opacityAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     currentIndex = widget.initialIndex;
//     pageController = PageController(initialPage: currentIndex);
//
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 250),
//     );
//
//     scaleAnimation = Tween(begin: 0.9, end: 1.0).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.easeOut),
//     );
//
//     opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.easeOut),
//     );
//
//     animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     pageController.dispose();
//     animationController.dispose();
//     super.dispose();
//   }
//
//   void toggleSelection(DreamDateItem item) {
//     widget.controller.toggleSelection(item);
//     setState(() {}); // Update the popup UI
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: opacityAnimation,
//       child: ScaleTransition(
//         scale: scaleAnimation,
//         child: Dialog(
//           backgroundColor: Colors.black,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 16),
//           child: SizedBox(
//             height: 350,
//             child: Stack(
//               children: [
//                 PageView.builder(
//                   controller: pageController,
//                   itemCount: widget.catalogList.length,
//                   onPageChanged: (index) {
//                     setState(() => currentIndex = index);
//                   },
//                   itemBuilder: (context, index) {
//                     final item = widget.catalogList[index];
//                     // Use GetBuilder inside each page to react to selection changes
//                     return GetBuilder<SelectDreamPartnerController>(
//                       builder: (controller) {
//                         final isSelected = controller.isSelected(item);
//
//                         return Stack(
//                           children: [
//                             Positioned.fill(
//                               child: AppCachedImage(
//                                 imageUrl: item.imageUrl ?? '',
//                                 fit: BoxFit.contain,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                             ),
//
//                             // Selection Button
//                             Positioned(
//                               bottom: 20,
//                               right: 20,
//                               child: GestureDetector(
//                                 onTap: () => toggleSelection(item),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.black54,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     isSelected
//                                         ? Icons.check_circle
//                                         : Icons.radio_button_unchecked,
//                                     color: isSelected
//                                         ? Colors.green
//                                         : Colors.white,
//                                     size: 32,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 // Close Button
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: IconButton(
//                     icon: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//
//                 // Page indicator
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black54,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       '${currentIndex + 1}/${widget.catalogList.length}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
void openBigImageSlider(
    BuildContext context,
    SelectDreamPartnerController controller,
    int initialIndex,
    ) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return BigImageSliderPopup(
        catalogList: controller.catalogListModel,
        initialIndex: initialIndex,
        controller: controller,
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}

class BigImageSliderPopup extends StatefulWidget {
  final List<DreamDateItem> catalogList;
  final int initialIndex;
  final SelectDreamPartnerController controller;

  const BigImageSliderPopup({
    super.key,
    required this.catalogList,
    required this.initialIndex,
    required this.controller,
  });

  @override
  State<BigImageSliderPopup> createState() => _BigImageSliderPopupState();
}

class _BigImageSliderPopupState extends State<BigImageSliderPopup>
    with SingleTickerProviderStateMixin {
  late int currentIndex;
  late CarouselSliderController carouselController;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
    carouselController = CarouselSliderController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    scaleAnimation = Tween(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggleSelection(DreamDateItem item) {
    widget.controller.toggleSelection(item);
    setState(() {}); // Update the popup UI
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height, // Slightly increased height for better viewing
              child: Center(
                child: Stack(
                  children: [
                    // Carousel Slider
                    CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: widget.catalogList.length,
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.4,
                        initialPage: currentIndex,
                        viewportFraction: 0.7,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        // enlargeFactor: 0.3,
                        onPageChanged: (index, reason) {
                          setState(() => currentIndex = index);
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        final item = widget.catalogList[index];
            
                        return GetBuilder<SelectDreamPartnerController>(
                          builder: (controller) {
                            final isSelected = controller.isSelected(item);
            
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black,
                              ),
                              child: Stack(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AppCachedImage(
                                      imageUrl: item.imageUrl ?? '',
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),

                                  // Selection Button
                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child: GestureDetector(
                                      onTap: () => toggleSelection(item),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isSelected
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: isSelected
                                              ? Colors.green
                                              : Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Close Button
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
