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
  static const String commentIcon = 'assets/svg/ic_comment.svg';
  static const String heartWhiteBG = 'assets/svg/ic_heart_white_bg.svg';
  static const String homeAppbar = 'assets/svg/ic_home_appbar.svg';
  static const String heartOnly = 'assets/svg/ic_heart_only.svg';
  static const String closeWhite = 'assets/svg/ic_close_white.svg';
  static const String leftArrow = 'assets/svg/ic_left_arrow.svg';
  static const String menuIcon = 'assets/svg/ic_menu.svg';
  static const String searchIcon = 'assets/svg/ic_search.svg';
  static const String sendButonIcon = 'assets/svg/ic_send_message.svg';
  static const String myProfileIcon = 'assets/svg/ic_my_profile.svg';
  static const String saveProfileIcon = 'assets/svg/ic_save_profile.svg';
  static const String changePasswordIcon = 'assets/svg/ic_change_password.svg';
  static const String profileVideoIcon = 'assets/svg/ic_360_video.svg';
  static const String subscriptionsIcon = 'assets/svg/ic_subscriptions.svg';
  static const String paymentIcon = 'assets/svg/ic_payment.svg';
  static const String helpSupportIcon = 'assets/svg/ic_help_support.svg';
  static const String feedbackIcon = 'assets/svg/ic_feedback.svg';
  static const String aboutUsIcon = 'assets/svg/ic_about_us.svg';
  static const String userLogoutIcon = 'assets/svg/ic_user_logout.svg';
  static const String rightArrowIcon = 'assets/svg/ic_right_arrow.svg';
  static const String userPlaceholder = 'assets/svg/user_placeholder.svg';
  static const String driveEtaIcon = 'assets/svg/ic_drive-eta.svg';
  static const String editProfileIcon = 'assets/svg/ic_edit_profile.svg';
  static const String starProfileIcon = 'assets/svg/ic_star_profile.svg';
  static const String helpCallIcon = 'assets/svg/ic_help_call.svg';
  static const String helpMailIcon = 'assets/svg/ic_help_mail.svg';

  static const String whatsAppIcon = 'assets/svg/ic_whatsapp.svg';
  static const String webSiteIcon = 'assets/svg/ic_website.svg';
  static const String facebookIcon = 'assets/svg/ic_facebook.svg';
  static const String twitterIcon = 'assets/svg/ic_twitter.svg';
  static const String instagramIcon = 'assets/svg/ic_instagram.svg';

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

  static Widget getHomeTabIcon(BuildContext context, {double size = 24, bool iconTintColor = false}) {
    return SvgPicture.asset(
        homeTabIcon,
        width: size.w,
        height: size.h,
      colorFilter: iconTintColor
          ? ColorFilter.mode(
        AppTheme.of(context).primaryColor,
        BlendMode.srcIn,
      )
          : null,
    );
  }

  static Widget getMatchesTabIcon(BuildContext context, {double size = 24, bool iconTintColor = false}) {
    return SvgPicture.asset(
        matchesTabIcon,
        width: size.w,
        height: size.h,
      colorFilter: iconTintColor
          ? ColorFilter.mode(
        AppTheme.of(context).primaryColor,
        BlendMode.srcIn,
      )
          : null,
    );
  }

  static Widget getMessageTabIcon(BuildContext context, {double size = 24, bool iconTintColor = false}) {
    return SvgPicture.asset(
        messageTabIcon,
        width: size.w,
        height: size.h,
      colorFilter: iconTintColor
          ? ColorFilter.mode(
        AppTheme.of(context).primaryColor,
        BlendMode.srcIn,
      )
          : null,
    );
  }

  static Widget getProfileTabIcon(BuildContext context, {double size = 24, bool iconTintColor = false}) {
    return SvgPicture.asset(
        profileTabIcon,
        width: size.w,
        height: size.h,
      colorFilter: iconTintColor
          ? ColorFilter.mode(
        AppTheme.of(context).primaryColor,
        BlendMode.srcIn,
      )
          : null,
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

  static Widget getCommentIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        commentIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getHeartWhiteBG(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        heartWhiteBG,
        width: size.w,
        height: size.h
    );
  }

  static Widget getHomeAppbar(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        homeAppbar,
        width: size.w,
        height: size.h
    );
  }

  static Widget getHeartOnly(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        heartOnly,
        width: size.w,
        height: size.h
    );
  }

  static Widget getCloseWhite(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        closeWhite,
        width: size.w,
        height: size.h
    );
  }

  static Widget getLeftArrow(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        leftArrow,
        width: size.w,
        height: size.h
    );
  }

  static Widget getSearchIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        searchIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getMenuIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        menuIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getSendMessageIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        sendButonIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getMyProfileIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        myProfileIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getSaveProfileIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        saveProfileIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getChangePasswordIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        changePasswordIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getProfileVideoIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        profileVideoIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getSubscriptionsIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        subscriptionsIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getPaymentIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        paymentIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getHelpSupportIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        helpSupportIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getFeedbackIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        feedbackIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getAboutUsIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        aboutUsIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getUserLogoutIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        userLogoutIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getRightArrowIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        rightArrowIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getUserPlaceHolder(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        userPlaceholder,
        width: size.w,
        height: size.h
    );
  }
  static Widget getDriveEtaIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        driveEtaIcon,
        width: size.w,
        height: size.h
    );
  }
  static Widget getEditProfileIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        editProfileIcon,
        width: size.w,
        height: size.h
    );
  }
  static Widget getStarProfileIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
        starProfileIcon,
        width: size.w,
        height: size.h
    );
  }

  static Widget getHelpMailIcon(BuildContext context, {double size = 48}) {
    return SvgPicture.asset(
      helpMailIcon,
      width: size.w,
      height: size.h,
    );
  }

  static Widget getHelpCallIcon(BuildContext context, {double size = 48}) {
    return SvgPicture.asset(
      helpCallIcon,
      width: size.w,
      height: size.h,
    );
  }

  static Widget getWhatsAppIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
      whatsAppIcon,
      width: size.w,
      height: size.h,
    );
  }

  static Widget getWebSiteIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
      webSiteIcon,
      width: size.w,
      height: size.h,
    );
  }

  static Widget getFacebookIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
      facebookIcon,
      width: size.w,
      height: size.h,
    );
  }

  static Widget getTwitterIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
      twitterIcon,
      width: size.w,
      height: size.h,
    );
  }

  static Widget getInstagramIcon(BuildContext context, {double size = 24}) {
    return SvgPicture.asset(
      instagramIcon,
      width: size.w,
      height: size.h,
    );
  }


// static Widget getEmptyBookingRequest(BuildContext context, {double size = 24}){
  //   return SvgPicture.asset(emptyBookingRequest,
  //     width: size,
  //     height: size,
  //   );
  // }
}