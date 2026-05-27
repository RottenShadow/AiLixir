abstract class AppEndpoints {
  // Base URLs
  static const String baseUrl =
      //'https://ailixirbackend-production-8e10.up.railway.app/api/';
      'https://america-hyperlipemic-grazyna.ngrok-free.dev/api/';

  // ── Auth Endpoints ──────────────────────────────────────
  static const String userAuthBaseUrl = 'user';
  static const String authBaseUrl = 'auth';

  static const String authGoogle = '$userAuthBaseUrl/$authBaseUrl/google';
  static const String userLogin = '$userAuthBaseUrl/login';
  static const String userRegister = '$userAuthBaseUrl/register';
  static const String userVerifyEmail = '$userAuthBaseUrl/verify-email';
  static const String userForgotPassword = '$userAuthBaseUrl/forgot-password';
  static const String userResendVerification =
      '$userAuthBaseUrl/resend-verification';
  static const String userResetPassword = '$userAuthBaseUrl/reset-password';
  static const String userLogout = '$userAuthBaseUrl/logout';

  // Drug Repurposing Endpoints
  static const String drugRepurposingBaseUrl =
      'https://rottenshadow-test-drug-purposing.hf.space/api/v1/screen';
  static const String drugRepurposingScreen = '/screen';
  static String drugRepurposingTargets(String diseaseName) {
    final String encodedDisease = Uri.encodeComponent(diseaseName);
    return '/targets/$encodedDisease';
  }
}
