class Endpoints {
  static const String baseUrl = 'http://airealconnect.com/api/v1/auth/';
  // static const String baseUrl = 'http://192.168.1.6:8000/api/v1/auth/';

  static const String userRegister = 'register';
  static const String userLogin = 'login';
  static const String verifyOtp = 'verify-otp';
  static const String resendOtp = 'resend-otp';

  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String verificationStatus = 'verification-status';
  static const String uploadVerificationVideo = 'upload-verification-video';
  static const String deleteSinglePhoto = 'photos';
  static const String uploadVerificationPhoto = 'upload-photo';
  static const String getPhotos = 'photos';
  static const String refreshToken = 'token/refresh';
  static const String meApi = 'me';
  static const String challenges = 'challenges';
  static const String getDreamCatalog = 'dream-date/catalog';
  static const String saveDreamDateSelect = 'dream-date/select';
  static const String getFeed = 'feed';
  static const String swipeCard = 'swipe';
  static const String getMatchesList = 'matches';
  static const String blockUser = 'block';
  static const String unBlockUser = 'unblock';
  static const String deleteAccount = 'delete-account';
  static const String matchProfileUser = 'users';
  static const String updateUserProfile = 'update-profile';
  static const String changePassword = 'change-password';
  static const String favoritesMatchProfile = 'favorites';
  static const String conversationsGetOrCreate = 'conversations/get-or-create';
  static const String getNotifications = 'notifications';
  static const String notificationsAcceptOrDecline = 'conversations';
  static const String faqsList = 'faqs';
  static const String logout = 'logout';
}
