import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double borderRadius;
  final BoxFit fit;
  final Color? backgroundColor;
  final Widget? errorWidget;
  final Widget? placeholder;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.errorWidget,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    print('imageUrl.isEmpty ${imageUrl.isEmpty}');
    print('imageUrl ${imageUrl}');
    print('borderRadius ${borderRadius}');

    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        // child: errorWidget ??
          child: AppIcons.getPlaceHolderGray(context, size: height ?? 100),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius.r),
      child: Container(
        height: height,
        width: width,
        color: backgroundColor ?? theme.containerBG,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.r),
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
          placeholder: (context, url) => Center(
            child: SizedBox(
              height: 24.w,
              width: 24.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => errorWidget ??
              AppIcons.getPlaceHolderGray(context, size: height ?? 100),
        ),
      ),
    );
  }
}
