class AppState {
  AppState._();

  static final AppState instance = AppState._();

  double? userLat;
  double? userLong;

  String? loginUserID;
  bool? isPremium;
  bool? isExpired;
  int? freeSwipesUsed;
  int? freeSwipesLimit;
}

class StringMessage {
  static const subscriptionExpiredTitle = 'Your Subscription Has Expired';
  static const subscriptionExpiredMessage = 'Your subscription has expired. Renew your monthly plan to continue enjoying unlimited swaps and full access.';

  static const freeSwapeTitle = 'You’ve Used All 3 Free Swaps';
  static const freeSwapeMessage = 'You’ve reached your free swap limit. Upgrade to a monthly plan to enjoy unlimited swaps and full access.';
}

class AppURL {
  static const termUrl = 'https://realtruedate.netlify.app/terms';
  static const policyUrl = 'https://realtruedate.netlify.app/privacy';
  static const aboutUsUrl = 'https://realtruedate.netlify.app/about';
}