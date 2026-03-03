import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

enum SkeletonType {
  home,
  service,
  details,
}

class GlobalSkeletonWrapper extends StatelessWidget {
  final SkeletonType type;

  const GlobalSkeletonWrapper({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: _buildSkeleton(context),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    switch (type) {
      case SkeletonType.home:
        return _buildHomeSkeleton(context);
      case SkeletonType.service:
        return _buildServiceSkeleton(context);
      case SkeletonType.details:
        return _buildDetailsSkeleton(context);

    }
  }

  // ------------------------------------
  // HOME PAGE
  // ------------------------------------
  Widget _buildHomeSkeleton(BuildContext context) {
    return Center(
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Image skeleton
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: double.infinity,
                height: 360,
                borderRadius: BorderRadius.circular(25),
              ),
            ),

            const SizedBox(height: 20),

            /// Name skeleton
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 20,
                width: 200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 10),

            /// Location skeleton
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 16,
                width: 140,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 25),

            /// Buttons skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 60,
                    height: 60,
                    shape: BoxShape.circle,
                  ),
                ),
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 70,
                    height: 70,
                    shape: BoxShape.circle,
                  ),
                ),
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 60,
                    height: 60,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------
  // SERVICE / CATEGORY PAGE
  // ------------------------------------
  Widget _buildServiceSkeleton(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 8,
      itemBuilder: (_, _) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: double.infinity,
                height: 120.h,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 12.h),
            SkeletonLine(style: _lineStyle(width: 100.w, height: 16.h)),
            SizedBox(height: 6.h),
            SkeletonLine(style: _lineStyle(width: double.infinity, height: 12.h)),
            SizedBox(height: 8.h),
            SkeletonLine(style: _lineStyle(width: 70.w, height: 28.h)),
          ],
        ),
      ),
    );
  }

  // ------------------------------------
  // MASSAGE DETAILS PAGE
  // ------------------------------------
  Widget _buildDetailsSkeleton(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              height: 220.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 16.h),
          SkeletonLine(style: _lineStyle(width: 200.w, height: 22.h)),
          SizedBox(height: 8.h),
          SkeletonLine(style: _lineStyle(width: double.infinity, height: 12.h)),
          SizedBox(height: 16.h),
          Column(
            children: List.generate(3, (_) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: SkeletonLine(
                  style: _lineStyle(width: double.infinity, height: 60.h),
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),
          SkeletonLine(style: _lineStyle(width: 160.w, height: 18.h)),
          SizedBox(height: 8.h),
          SkeletonLine(style: _lineStyle(width: double.infinity, height: 120.h)),
          SizedBox(height: 20.h),
          SkeletonLine(style: _lineStyle(width: double.infinity, height: 48.h)),
        ],
      ),
    );
  }

  // ------------------------------------
  // BOOKING / SLOT PAGE
  // ------------------------------------
  Widget _buildBookingSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(style: _lineStyle(width: 140.w, height: 20.h)),
        SizedBox(height: 12.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 80.h)),
        SizedBox(height: 20.h),
        SkeletonLine(style: _lineStyle(width: 160.w, height: 20.h)),
        SizedBox(height: 12.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 120.h)),
        SizedBox(height: 24.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 56.h)),
      ],
    );
  }

  // ------------------------------------
  // CART / CHECKOUT PAGE
  // ------------------------------------
  Widget _buildCartSkeleton(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(style: _lineStyle(width: 180.w, height: 18.h)),
          SizedBox(height: 16.h),
          // SkeletonLine(style: _lineStyle(width: double.infinity, height: 120.h)),
          _buildBookingListCardSkeleton(context),
          SizedBox(height: 24.h),
          SkeletonLine(style: _lineStyle(width: 140.w, height: 18.h)),
          SizedBox(height: 12.h),
          SizedBox(
            height: 90.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => SizedBox(width: 12.w),
              itemBuilder: (_, _) => SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: 80.w,
                  height: 80.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SkeletonLine(style: _lineStyle(width: 160.w, height: 20.h)),
          SizedBox(height: 8.h),
          SkeletonLine(style: _lineStyle(width: double.infinity, height: 48.h)),
          SizedBox(height: 12.h),
          SkeletonLine(style: _lineStyle(width: double.infinity, height: 48.h)),
          // SizedBox(height: 24.h),
          // SkeletonLine(style: _lineStyle(width: double.infinity, height: 56.h)),
        ],
      ),
    );
  }

  // ------------------------------------
  // REUSABLE ELEMENTS
  // ------------------------------------
  Widget _buildCardSkeleton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              height: 160.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 16.h),
          SkeletonLine(style: _lineStyle(width: 160.w, height: 18.h)),
          SizedBox(height: 8.h),
          SkeletonLine(style: _lineStyle(width: double.infinity, height: 12.h)),
          SizedBox(height: 4.h),
          SkeletonLine(style: _lineStyle(width: MediaQuery.of(context).size.width * 0.6, height: 12.h)),
          SizedBox(height: 12.h),
          SkeletonLine(style: _lineStyle(width: 80.w, height: 12.h)),
        ],
      ),
    );
  }

  SkeletonLineStyle _lineStyle({
    required double width,
    required double height,
  }) {
    return SkeletonLineStyle(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  Widget _buildBookingTimeSlotSelectSkeleton(BuildContext context) {
    return SingleChildScrollView(
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ------------------------
          // Instant Card Skeleton
          // ------------------------
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16.h,
                    width: 60.w,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 12.h),

                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 20.h,
                    // width: 140.w,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 12.h),

                Row(
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 16.h,
                        width: 16.w,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 16.h,
                        width: 130.w,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ------------------------
          // Schedule For Later Card
          // ------------------------
          Container(
            padding: EdgeInsets.only(top: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 20.h,
                    width: 150.w,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),

                SizedBox(height: 8.h),

                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 14.h,
                    width: 200.w,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),

                SizedBox(height: 16.h),

                // Date buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (_) {
                    return Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          // SkeletonLine(
                          //   style: SkeletonLineStyle(
                          //     height: 16.h,
                          //     width: 30.w,
                          //     borderRadius: BorderRadius.circular(6.r),
                          //   ),
                          // ),
                          // SizedBox(height: 8.h),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 60.h,
                              width: 60.w,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                SizedBox(height: 30.h),

                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16.h,
                    width: 180.w,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),

                SizedBox(height: 14.h),

                // Time Slots grid
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: List.generate(6, (_) {
                    return Container(
                      width: (MediaQuery.of(context).size.width / 3).w - 50.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 38.h,
                          width: 100.w,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          SizedBox(height: 30.h),

          // ------------------------
          // Bottom Add to Cart Button
          // ------------------------
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 50.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSelectSkeleton(BuildContext context) {
    return SingleChildScrollView(
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ------------------------
          // Schedule For Later Card
          // ------------------------
          Container(
            padding: EdgeInsets.only(top: 0.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Slots grid
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(6, (_) {
                    return Container(
                      width: (MediaQuery.of(context).size.width / 3).w - 60.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 35.h,
                          width: 100.w,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------
  // ADDRESS LIST
  // ------------------------------------
  Widget _addressListSkeleton(BuildContext context) {
    return Column(
      children: List.generate(4, (_) => _buildAddressRowSkeleton(context)),
    );
  }

  Widget _buildAddressRowSkeleton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.w),
      child: SizedBox(
        height: 70.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Left Location Icon
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 22.h,
                width: 22.w,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),

            SizedBox(width: 12.h),

            // Title + Address
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 18.h,
                      width: 60.w,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // 3-line Address
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 14.h,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 14.h,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  // SizedBox(height: 6.h),
                  // SkeletonLine(
                  //   style: SkeletonLineStyle(
                  //     height: 14.h,
                  //     width: 140.w, // last line shorter
                  //     borderRadius: BorderRadius.circular(6.r),
                  //   ),
                  // ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Edit Icon
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 20.h,
                width: 20.w,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),

            SizedBox(width: 12.w),

            // Delete Icon
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 20.h,
                width: 20.w,
                borderRadius: BorderRadius.circular(6.r),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ------------------------------------
  // BOOKING LIST
  // ------------------------------------
  Widget _buildBookingListCardSkeleton(BuildContext context) {
    return Column(
      children: List.generate(2, (_) => _buildBookingCardSkeleton(context)),
    );
  }

  Widget _buildBookingCardSkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.h, vertical: 12.w),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(14.r),
      //   border: Border.all(color: Colors.black12),
      // ),
      child: Stack(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 98.h,
                  width: 107.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),

              SizedBox(width: 14.w),

              // Text column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 18.h,
                        width: 140.w,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 14.h,
                        width: 120.w,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 14.h,
                        width: 100.w,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Status "Pending" badge shimmer
          Positioned(
            right: 1.w,
            top: 1.h,
            child: SkeletonLine(
              style: SkeletonLineStyle(
                height: 15.h,
                width: 50.w,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------
  // BOOKING INFO
  // ------------------------------------
  Widget _buildBookingInfoSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        children: [

          // -----------------------------
          // TOP STATUS TIMELINE CARD
          // -----------------------------
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 18.h),
                  child: Row(
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 26.h,
                          width: 26.w,
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 16.h,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 20.h),

          // -----------------------------
          // EXPERT INFO CARD
          // -----------------------------
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 56.h,
                    width: 56.w,
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),

                SizedBox(width: 14.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 16.h,
                          width: 140.w,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 14.h,
                          width: 110.w,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  ),
                ),

                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16.h,
                    width: 70.w,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // -----------------------------
          // BOOKING SUMMARY CARD
          // -----------------------------
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.black12),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 70.h,
                        width: 70.w,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    SizedBox(width: 14.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 18.h,
                              width: 160.w,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 14.h,
                              width: 120.w,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Positioned(
                  right: 0,
                  child: SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 22.h,
                      width: 70.w,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------
  // COUPON PAGE
  // ------------------------------------
  Widget _buildCouponSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(style: _lineStyle(width: 100.w, height: 20.h)),
        SizedBox(height: 10.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 40.h)),
        SizedBox(height: 10.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 40.h)),
        SizedBox(height: 30.h),

        SkeletonLine(style: _lineStyle(width: 100.w, height: 20.h)),
        SizedBox(height: 10.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 40.h)),
        SizedBox(height: 10.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 40.h)),
        SizedBox(height: 10.h),
        SkeletonLine(style: _lineStyle(width: double.infinity, height: 40.h)),
      ],
    );
  }
}

// ------------------------------------
// NOTIFICATION LIST PAGE
// ------------------------------------
Widget notificationItemSkeleton() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Icon
        SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: 24.w,
            height: 24.h,
            shape: BoxShape.circle,
          ),
        ),

        SizedBox(width: 12.w),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16.h,
                  width: 180.w,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(height: 6.h),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 14.h,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(height: 6.h),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 12.h,
                  width: 80.w,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget notificationSectionTitleSkeleton() {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
    child: SkeletonLine(
      style: SkeletonLineStyle(
        height: 18.h,
        width: 160.w,
        borderRadius: BorderRadius.circular(6.r),
      ),
    ),
  );
}

Widget _notificationsSkeleton(BuildContext context) {
  return ListView(
    children: [

      // Today
      notificationSectionTitleSkeleton(),
      notificationItemSkeleton(),
      notificationItemSkeleton(),

      SizedBox(height: 16.h),

      // Previous notifications
      notificationSectionTitleSkeleton(),
      notificationItemSkeleton(),
      notificationItemSkeleton(),
    ],
  );
}

// ------------------------------------
// TERM AND CONDITION PAGE
// ------------------------------------

Widget _termsConditionsSkeleton(BuildContext context) {
  return SingleChildScrollView(
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // First paragraph
        paragraphSkeleton(lines: 8),

        SizedBox(height: 28.h),

        // Second paragraph
        paragraphSkeleton(lines: 6),
      ],
    ),
  );
}

Widget paragraphSkeleton({int lines = 6}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(lines, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: SkeletonLine(
          style: SkeletonLineStyle(
            height: 14.h,
            width: index == lines - 1
                ? 180.w // last line shorter
                : double.infinity,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      );
    }),
  );
}

