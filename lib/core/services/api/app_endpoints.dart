abstract class AppEndpoints {
  // Base URLs
  static const String baseUrl =
      'https://cristine-uninstanced-unforeseeably.ngrok-free.dev/api/';

  static const String authBaseUrl = 'auth';

  // Auth Endpoints

  static const String authSignUp = '$authBaseUrl/signup';
  static const String authLogin = '$authBaseUrl/login';
  static const String authResendVerificationOtp =
      '$authBaseUrl/resend-verification-otp';
  static const String authCompleteLoginOtp = '$authBaseUrl/complete-login-otp';
  static const String authGoogle = 'user/$authBaseUrl/google';
  static const String authFacebook = '$authBaseUrl/facebook';
  static const String authForgotPassword = '$authBaseUrl/forgotPassword';
  static const String authVerifyPasswordOtp = '$authBaseUrl/verify-otp';
  static const String authResetPassword = '$authBaseUrl/resetpassword';
  static const String authRefreshToken = '$authBaseUrl/refresh-token';
  static const String authUpdatePassword = '$authBaseUrl/password';
  static const String authLogout = '$authBaseUrl/logout';
}
