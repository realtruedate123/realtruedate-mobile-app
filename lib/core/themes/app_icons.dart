import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:get/get.dart';

class AppIcons{

  /// SVG
  static const String splashImage = 'assets/svg/bg_splash.svg';
  static const String getImagePlaceholderImage = 'assets/svg/bg_splash.svg';
  static const String onBoardPlayIcon = 'assets/svg/ic_play.svg';
  static const String backIcon = 'assets/svg/ic_back_white.svg';
  static const String headerImage = 'assets/svg/ic_header.svg';
  static const String passwordIcon = 'assets/svg/ic_password.svg';
  static const String emailIcon = 'assets/svg/ic_email.svg';
  static const String eyeOnIcon = 'assets/svg/ic_eye_on.svg';
  static const String backOutLineIcon = 'assets/svg/ic_back_outline.svg';
  static const String arrowDown = 'assets/svg/ic_arrow_down.svg';
  static const String birthdayIcon = 'assets/svg/ic_birthday.svg';
  static const String calendarIcon = 'assets/svg/ic_calendar.svg';
  static const String cameraIcon = 'assets/svg/ic_camera.svg';
  static const String checkMark = 'assets/svg/ic_check_mark.svg';
  static const String crossDelete = 'assets/svg/ic_cross_delete.svg';
  static const String peopleIcon = 'assets/svg/ic_people.svg';
  static const String placeIcon = 'assets/svg/ic_place.svg';
  static const String shareIcon = 'assets/svg/ic_share.svg';
  static const String uncheckMark = 'assets/svg/ic_uncheck_mark.svg';
  static const String playWhite = 'assets/svg/ic_play_white.svg';
  static const String dotIcon = 'assets/svg/ic_dot.svg';
  static const String logOutIcon = 'assets/svg/ic_logout.svg';
  static const String homeTabIcon = 'assets/svg/ic_home.svg';
  static const String matchesTabIcon = 'assets/svg/ic_matches.svg';
  static const String messageTabIcon = 'assets/svg/ic_message.svg';
  static const String profileTabIcon = 'assets/svg/ic_profile.svg';
  static const String favouriteIcon = 'assets/svg/ic_favourite.svg';
  static const String notificationIcon = 'assets/svg/ic_notification.svg';
  static const String cancelCardIcon = 'assets/svg/ic_cancel_card.svg';
  static const String favouriteCardIcon = 'assets/svg/ic_favourite_card.svg';
  static const String greenTickIcon = 'assets/svg/ic_green_tick.svg';
  static const String likeCardIcon = 'assets/svg/ic_like_card.svg';
  static const String cancelCardFillIcon = 'assets/svg/ic_cancel_card_fill.svg';
  static const String likeCardUnfillIcon = 'assets/svg/ic_like_card_unfill.svg';
  static const String favouriteWhiteIcon = 'assets/svg/ic_favourite_white.svg';
  static const String startFillOutlineIcon = 'assets/svg/ic_start_fill_outline.svg';
  static const String startUnfillOutlineIcon = 'assets/svg/ic_start_unfill_outline.svg';
  static const String tickOutlineIcon = 'assets/svg/ic_tick_outline.svg';
  static const String closeRedIcon = 'assets/svg/ic_close_red.svg';
  static const String placeHolderGray = 'assets/svg/placeholder_gray.svg';
  static const String onlyGreenTick = 'assets/svg/ic_only_green_tick.svg';

  /// PNG
  static const String splashImagePng = 'assets/png/bg_splash.png';
  static const String headerImagePng = 'assets/png/ic_header.png';
  static const String headerHalfImagePng = 'assets/png/ic_half_header.png';
  static const String dummyProfileCard = 'assets/png/dummy_profile_card.png';
  static const String dummyProfileDetailsCard = 'assets/png/dummy_profile_details.png';

  /// GIF
  static const String gifLogo = 'assets/gif/gif_logo.gif';
  static const String gifImageVideoScan = 'assets/gif/image_video_scan_gif.gif';

  /// VIDEO


  static Widget getSplashImage(BuildContext context) {
    return SvgPicture.asset(
      splashImage,
      fit: BoxFit.cover,
    );
  }

  static Widget getImagePlaceholder(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(headerImage, fit: BoxFit.cover , width: size.w, height: size.h,);
  }

  static Widget getHomeBanner() {
    return SvgPicture.asset('assets/svg/home_banner.svg', fit: BoxFit.cover);
  }

  static Widget getOnBoardPlayIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        onBoardPlayIcon,
      width: size.w,
      height: size.h
    );
  }

  static Widget getBackButtonIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        backIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getPasswordIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        passwordIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getEmailIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        emailIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getEyeOnIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        eyeOnIcon,
        width: size.w,
        height: size.h,
        // colorFilter: ColorFilter.mode(
        //   AppTheme.of(Get.context!).iconTintColor, // The color you want to apply
        //   BlendMode.srcIn, // The standard blend mode for applying a single color
        // )
    );
  }

  static Widget getBackOutLineIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        backOutLineIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getDownArrowIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        arrowDown,
        width: size.w,
        height: size.h
    );
  }

  static Widget getBirthdayIcon(BuildContext context, {double size = 24, Color? color}) {
    final Color iconColor =
        color ?? AppTheme.of(context).iconTintColor; // default color

    return SvgPicture.asset(
        birthdayIcon,
        width: size.w,
        height: size.h,
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn, // The standard blend mode for applying a single color
        )
    );
  }

  static Widget getCalendarIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        calendarIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getCameraIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        cameraIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getCheckMarkIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        checkMark,
        width: size.w,
        height: size.h
    );
  }

  static Widget getUnCheckMarkIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        uncheckMark,
        width: size.w,
        height: size.h
    );
  }

  static Widget getCrossDeleteIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        crossDelete,
        width: size.w,
        height: size.h
    );
  }

  static Widget getPeopleIcon(BuildContext context, {double size = 24, Color? color,}) {
    final Color iconColor =
        color ?? AppTheme.of(context).iconTintColor; // default color

    return SvgPicture.asset(
        peopleIcon,
        width: size.w,
        height: size.h,
      colorFilter: ColorFilter.mode(
        iconColor,
        BlendMode.srcIn, // The standard blend mode for applying a single color
      )
    );
  }

  static Widget getPlaceIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        placeIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getShareIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        shareIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getPlayWhiteIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        playWhite,
        width: size.w,
        height: size.h
    );
  }

  static Widget getDotIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        dotIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getLogOutIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        logOutIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getHomeTabIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        homeTabIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getMatchesTabIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        matchesTabIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getMessageTabIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        messageTabIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getProfileTabIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        profileTabIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getFavouriteIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        favouriteIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getNotificationIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        notificationIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getCancelCardIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        cancelCardIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getFavouriteCardIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        favouriteCardIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getGreenTickIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        greenTickIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getLikeCardIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        likeCardIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getStartUnfillOutlineIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        startUnfillOutlineIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getStartFillOutlineIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        startFillOutlineIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getTickOutlineIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        tickOutlineIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getCloseRedIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        closeRedIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getPlaceHolderGray(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        placeHolderGray,
        width: size.w,
        height: size.h
    );
  }

  static Widget getOnlyGreenTick(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        onlyGreenTick,
        width: size.w,
        height: size.h
    );
  }

// static Widget getEmptyBookingRequest(BuildContext context, {double size = 24}){
  //   return SvgPicture.asset(emptyBookingRequest,
  //     width: size,
  //     height: size,
  //   );
  // }
}