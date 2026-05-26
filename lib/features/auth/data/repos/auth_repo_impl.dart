import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:ailixir/features/auth/data/model/auth/auth_token_user_response.dart';
import 'package:ailixir/features/auth/data/services/auth_api_service.dart';

/// Repository for the 5 new user-prefixed auth endpoints.
/// Wraps [AuthApiService] with error handling and token persistence.
class AuthRepoImpl {
  final AuthApiService _api;
  final LocalAuthDataSource _local;

  const AuthRepoImpl({
    required AuthApiService authApiService,
    required LocalAuthDataSource localAuthDataSource,
  }) : _api = authApiService,
       _local = localAuthDataSource;

  // ── 1. Login ──────────────────────────────────────────────────────────────

  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) => safeApiCall(() async {
    final res = await _api.login(email: email, password: password);
    if (res.data != null) {
      await _persistSession(res.data!);
    }
    return res.message;
  });

  // ── 2. Register ───────────────────────────────────────────────────────────

  /// Returns the email address so the caller can route to OTP verification.
  Future<Either<Failure, String>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) => safeApiCall(() async {
    final res = await _api.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    // Return the email so the UI can pre-fill the verify screen.
    return res.data?.email ?? email;
  });

  // ── 3. Verify Email ───────────────────────────────────────────────────────

  Future<Either<Failure, String>> verifyEmail({
    required String email,
    required String otp,
  }) => safeApiCall(() async {
    final res = await _api.verifyEmail(email: email, otp: otp);
    if (res.data != null) {
      await _persistSession(res.data!);
    }
    return res.message;
  });

  // ── 4. Forgot Password ────────────────────────────────────────────────────

  /// Returns the email so the UI can route to the OTP entry screen.
  Future<Either<Failure, String>> forgotPassword({required String email}) =>
      safeApiCall(() async {
        final res = await _api.forgotPassword(email: email);
        return res.data?.email ?? email;
      });

  // ── 5. Reset Password ─────────────────────────────────────────────────────

  /// Resets the user's password using the OTP received by email.
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) => safeApiCall(() async {
    final res = await _api.resetPassword(
      email: email,
      otp: otp,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return res.message;
  });

  // ── 6. Resend Verification ────────────────────────────────────────────────

  Future<Either<Failure, String>> resendVerification({required String email}) =>
      safeApiCall(() async {
        final res = await _api.resendVerification(email: email);
        return res.message;
      });

  // ── 7. Force Logout ────────────────────────────────────────────────

  Future<Either<Failure, String>> forceLogout() => safeApiCall(() async {
    final res = await _api.forceLogout();
    await _local.clearUserTokensAndData();
    return res.message;
  });

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Stores the token in [FlutterSecureStorage] and caches user data in
  /// [SharedPreferences] via the existing [LocalAuthDataSource].
  Future<void> _persistSession(AuthTokenUserResponse data) async {
    await _local.saveAllUserData(authTokenUserResponse: data);
    log('Session persisted for ${data.user.email}');
  }
}
