abstract class AppEndpoints {
  // Base URLs
  static const String baseUrl =
      'https://rottenshadow-ailixir-api.hf.space/api/';

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

  // ADMET Prediction Endpoints
  static const String admetPredict = 'admet/predict';

  // Drug Repurposing Endpoints
  static const String drugRepurposingScreen = '/drug-repurposing/screen';
  static const String drugRepurposingTargets = '/drug-repurposing/targets';

  // ── AI Generation Endpoints ───────────────────────────
  static const String generationRun = 'ai/generation/run';
  static String generationStatus(String jobId) => 'ai/generation/status/$jobId';
  static String generationResults(String jobId) =>
      'ai/generation/jobs/$jobId/results';
  static const String ligandsExport = 'ai/ligands/export';
  static String aiFiles(String jobId, String filename) =>
      'ai/files/$jobId/$filename';

  // ── Docking Endpoints ─────────────────────────────────
  static const String dockingSubmit = 'docking/submit';
  static String dockingJob(int id) => 'docking/$id';
  static const String dockingHistory = 'docking/history';
  static String dockingDownload(int id) => 'docking/download/$id';

  // ── Chemical Search Endpoints ─────────────────────────
  static const String chemicalSearch = 'chemical-search';
  static const String chemicalSearchFullRag = 'chemical-search/full-rag';

  // ── History Endpoints ─────────────────────────────────
  static const String aiJobHistory = 'ai/history';
  static const String chemistryHistory = 'chemistry/history';
}
