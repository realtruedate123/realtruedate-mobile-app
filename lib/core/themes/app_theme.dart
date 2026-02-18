import 'package:flutter/material.dart';

abstract class AppThemeColors {
  Color get text;
  Color get primaryColor;
  Color get lightPurpleColor;
  Color get lightBlackColor;
  Color get lightGrayColor;
  Color get headerTitleColor;
  Color get segmentBGColor;
  Color get iconTintColor;
  Color get iconTintHighlightColor;
  Color get textDisableColor;
  Color get hintText;
  Color get border;
  Color get dropShadow;
  Color get darkGray;
  Color get lightBlueColor;
  Color get whiteColor;
  Color get blackColor;
  Color get inactiveTabColor;
  Color get greenButtonColor;
  Color get notificationBGColor;
  Color get lightGrayBGColor;
  Color get offWhiteBGColor;
  Color get darkGrayColor;
  Color get messageCountColor;
  Color get chatTitleColor;


  Color get subTitleText;
  Color get buttonBG;

  Color get buttonText;
  Color get headingText;
  Color get alert;
  Color get dark;

  Color get highlight;
  Color get process;
  Color get containerBG;
  Color get orangeColor;
}

class LightTheme implements AppThemeColors {

  @override
  Color get text => Color(0xFF453D78);

  @override
  Color get primaryColor => Color(0xFF5D5494);

  @override
  Color get lightPurpleColor => Color(0xFFEE9EA9);

  @override
  Color get lightBlackColor => Color(0xFF404040);

  @override
  Color get lightGrayColor => Color(0xFFD7D7D7);

  @override
  Color get headerTitleColor => Color(0xFF27364E);

  @override
  Color get segmentBGColor => Color(0xFFEAECF0);

  @override
  Color get iconTintColor => Color(0xFFADB4C0);

  @override
  Color get iconTintHighlightColor => Color(0xFF2C4364);

  @override
  Color get textDisableColor => Color(0xFF838FA0);

  @override
  Color get hintText => Color(0xFF616161);

  @override
  Color get border => Color(0xFFE0E0E0);

  @override
  Color get dropShadow => Color(0xFF5D6976);

  @override
  Color get darkGray => Color(0xFFC4C4C4);

  @override
  Color get lightBlueColor => Color(0xFF282A37);

  @override
  Color get whiteColor => Color(0xFFFFFFFF);

  @override
  Color get blackColor => Color(0xFF000000);

  @override
  Color get inactiveTabColor => Color(0xFFB0B0B0);

  @override
  Color get greenButtonColor => Color(0xFF0BA970);

  @override
  Color get notificationBGColor => Color(0xFFFEF4F5);

  @override
  Color get lightGrayBGColor => Color(0xFFEDEDED);

  @override
  Color get offWhiteBGColor => Color(0xFFF8F9F9);

  @override
  Color get darkGrayColor => Color(0xFF5D6066);

  @override
  Color get messageCountColor => Color(0xFFFFA8A7);

  @override
  Color get chatTitleColor => Color(0xFF27292E);



  @override
  Color get subTitleText => Color(0xFF666666);

  @override
  Color get buttonBG => Color(0xFF333333);

  @override
  Color get buttonText => Color(0xFFFFFFFF);

  @override
  Color get headingText => Color(0xFF262626);

  @override
  Color get alert => Color(0xFFDD5050);

  @override
  Color get dark => Color(0xFF000000);

  @override
  Color get highlight => Color(0xFFFFC107);

  @override
  Color get process => Color(0xFF4CAF50);

  @override
  Color get containerBG => Color(0xFFF2F2F2);

  @override
  Color get orangeColor => Color(0xFFFF8C00);
}

class DarkTheme implements AppThemeColors {


  @override
  Color get text => const Color(0xFF453D78);

  @override
  Color get primaryColor => const Color(0xFF5D5494);

  @override
  Color get lightPurpleColor => Color(0xFFEE9EA9);

  @override
  Color get lightBlackColor => Color(0xFF404040);

  @override
  Color get lightGrayColor => Color(0xFFD7D7D7);

  @override
  Color get headerTitleColor => Color(0xFF27364E);

  @override
  Color get segmentBGColor => Color(0xFFEAECF0);

  @override
  Color get iconTintColor => Color(0xFFADB4C0);

  @override
  Color get iconTintHighlightColor => Color(0xFF2C4364);

  @override
  Color get textDisableColor => Color(0xFF838FA0);

  @override
  Color get hintText => Color(0xFF616161);

  @override
  Color get border => Color(0xFFE0E0E0);

  @override
  Color get dropShadow => Color(0xFF5D6976);

  @override
  Color get darkGray => Color(0xFFC4C4C4);

  @override
  Color get lightBlueColor => Color(0xFF282A37);

  @override
  Color get whiteColor => Color(0xFFFFFFFF);

  @override
  Color get blackColor => Color(0xFF000000);

  @override
  Color get inactiveTabColor => Color(0xFFB0B0B0);

  @override
  Color get greenButtonColor => Color(0xFF0BA970);

  @override
  Color get notificationBGColor => Color(0xFFFEF4F5);

  @override
  Color get lightGrayBGColor => Color(0xFFEDEDED);

  @override
  Color get offWhiteBGColor => Color(0xFFF8F9F9);

  @override
  Color get darkGrayColor => Color(0xFF5D6066);

  @override
  Color get messageCountColor => Color(0xFFFFA8A7);

  @override
  Color get chatTitleColor => Color(0xFF27292E);



  @override
  Color get subTitleText => const Color(0xFF666666);

  @override
  Color get buttonBG => const Color(0xFF333333);

  @override
  Color get buttonText => Color(0xFFFFFFFF);

  @override
  Color get headingText => Color(0xFF262626);

  @override
  Color get alert => Color(0xFFDD5050);

  @override
  Color get dark => Color(0xFF000000);


  @override
  Color get highlight => Color(0xFFFFC107);

  @override
  Color get process => Color(0xFF4CAF50);

  @override
  Color get containerBG => Color(0xFFF2F2F2);

  @override
  Color get orangeColor => Color(0xFFFF8C00);
}

class AppTheme {
  static final light = LightTheme();
  static final dark = DarkTheme();

  static AppThemeColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}
