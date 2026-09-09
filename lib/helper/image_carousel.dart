import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_svg/svg.dart';

enum CarouselImageType { network, assetPng, assetSvg }

class CarouselImage {
  final String path;
  final CarouselImageType type;

  const CarouselImage.network(this.path)
      : type = CarouselImageType.network;

  const CarouselImage.assetPng(this.path)
      : type = CarouselImageType.assetPng;

  const CarouselImage.assetSvg(this.path)
      : type = CarouselImageType.assetSvg;
}

class GlobalImageCarousel extends StatefulWidget {
  final List<CarouselImage> images;
  final Function(int, CarouselPageChangedReason)? onPageChanged;
  final CarouselSliderController? controller;
  final double height;
  final Color? backgroundColor;
  final double viewportFraction;
  final bool autoPlay;
  final bool enlargeCenterPage;
  final BorderRadius? borderRadius;
  final int initialPage;
  final BoxFit fit;
  final bool disableScrolling;
  final Color activeDotColor;
  final Color inactiveDotColor;

  const GlobalImageCarousel({
    super.key,
    required this.images,
    this.onPageChanged,
    this.controller,
    this.height = 148,
    this.backgroundColor,
    this.viewportFraction = 0.8,
    this.autoPlay = true,
    this.enlargeCenterPage = true,
    this.borderRadius,
    this.initialPage = 0,
    this.fit = BoxFit.cover,
    this.disableScrolling = false,
    this.activeDotColor = Colors.deepPurple,
    this.inactiveDotColor = Colors.grey,
  });
  @override
  State<GlobalImageCarousel> createState() => _GlobalImageCarouselState();
}

class _GlobalImageCarouselState extends State<GlobalImageCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();
  late int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: widget.height,
              autoPlay: widget.autoPlay,
              enlargeCenterPage: widget.enlargeCenterPage,
              viewportFraction: widget.viewportFraction,
              initialPage: widget.initialPage,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
              scrollPhysics: widget.disableScrolling
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
            ),
            items: widget.images.map((image) {
              return ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12.r),
                child: Container(
                  color: widget.backgroundColor ?? Colors.transparent,
                  width: double.infinity,
                  child: _buildImage(context, image),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),

          /// 🔹 Dots
          _CarouselDots(
            count: widget.images.length,
            currentIndex: _currentIndex,
            activeColor: widget.activeDotColor,
            inactiveColor: widget.inactiveDotColor,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, CarouselImage image) {
    switch (image.type) {
      case CarouselImageType.network:
        return CachedNetworkImage(
          imageUrl: image.path,
          fit: widget.fit,
          progressIndicatorBuilder: (_, __, progress) => Center(
            child: SizedBox(
              width: 28.w,
              height: 28.w,
              child: CircularProgressIndicator(
                value: progress.progress,
                strokeWidth: 2.w,
              ),
            ),
          ),
          errorWidget: (_, __, ___) =>
              AppIcons.getImagePlaceholder(context, size: widget.height),
        );

      case CarouselImageType.assetPng:
        return Image.asset(
          image.path,
          fit: widget.fit,
        );

      case CarouselImageType.assetSvg:
        return SvgPicture.asset(
          image.path,
          fit: widget.fit,
        );
    }
  }
}

class _CarouselDots extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  const _CarouselDots({
    required this.count,
    required this.currentIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 21.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor
                : inactiveColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
