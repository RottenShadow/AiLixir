import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/features/auth/data/model/auth/auth_email_response.dart';
import 'package:ailixir/features/auth/data/model/auth/auth_token_user_response.dart';

/// Strongly-typed network service for all 5 user-auth endpoints.
/// Each method returns the parsed [BaseResponseModel<T>] so callers never
/// touch raw JSON.
class AuthApiService {
  final DioService _dio;

  const AuthApiService({required DioService dioService}) : _dio = dioService;

  // ── 1. Login ──────────────────────────────────────────────────────────────

  /// POST /api/user/login
  /// Returns token + full user object on success.
  Future<BaseResponseModel<AuthTokenUserResponse>> login({
    required String email,
    required String password,
  }) async {
    final raw =
        await _dio.post(
              endpoint: AppEndpoints.userLogin,
              data: {'email': email, 'password': password},
            )
            as Map<String, dynamic>;

    return BaseResponseModel.fromJson(
      raw,
      (d) => AuthTokenUserResponse.fromJson(d as Map<String, dynamic>),
    );
  }

  // ── 2. Register ───────────────────────────────────────────────────────────

  /// POST /api/user/register
  /// Returns the registered email; user must verify via OTP next.
  Future<BaseResponseModel<AuthEmailResponse>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final raw =
        await _dio.post(
              endpoint: AppEndpoints.userRegister,
              data: {
                'name': name,
                'email': email,
                'password': password,
                'password_confirmation': passwordConfirmation,
              },
            )
            as Map<String, dynamic>;

    return BaseResponseModel.fromJson(
      raw,
      (d) => AuthEmailResponse.fromJson(d as Map<String, dynamic>),
    );
  }

  // ── 3. Verify Email (OTP) ─────────────────────────────────────────────────

  /// POST /api/user/verify-email
  /// Returns token + full user object after successful OTP verification.
  Future<BaseResponseModel<AuthTokenUserResponse>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final raw =
        await _dio.post(
              endpoint: AppEndpoints.userVerifyEmail,
              data: {'email': email, 'otp': otp},
            )
            as Map<String, dynamic>;

    return BaseResponseModel.fromJson(
      raw,
      (d) => AuthTokenUserResponse.fromJson(d as Map<String, dynamic>),
    );
  }

  // ── 4. Forgot Password ────────────────────────────────────────────────────

  /// POST /api/user/forgot-password
  /// Sends a password-reset OTP to the given email.
  Future<BaseResponseModel<AuthEmailResponse>> forgotPassword({
    required String email,
  }) async {
    final raw =
        await _dio.post(
              endpoint: AppEndpoints.userForgotPassword,
              data: {'email': email},
            )
            as Map<String, dynamic>;

    return BaseResponseModel.fromJson(
      raw,
      (d) => AuthEmailResponse.fromJson(d as Map<String, dynamic>),
    );
  }

  // ── 5. Reset Password ─────────────────────────────────────────────────────

  /// POST /api/user/reset-password
  /// Resets the user's password using the OTP received by email.
  Future<BaseResponseModel<void>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    final raw =
        await _dio.post(
              endpoint: AppEndpoints.userResetPassword,
              data: {
                'email': email,
                'otp': otp,
                'password': password,
                'password_confirmation': passwordConfirmation,
              },
            )
            as Map<String, dynamic>;

    return BaseResponseModel.fromJson(raw, (_) {});
  }

  // ── 6. Resend Verification ────────────────────────────────────────────────

  /// POST /api/user/resend-verification
  /// Re-sends the email-verification OTP.
  Future<BaseResponseModel<AuthEmailResponse>> resendVerification({
    required String email,
  }) async {
    final raw =
        await _dio.post(
              endpoint: AppEndpoints.userResendVerification,
              data: {'email': email},
            )
            as Map<String, dynamic>;

    return BaseResponseModel.fromJson(
      raw,
      (d) => AuthEmailResponse.fromJson(d as Map<String, dynamic>),
    );
  }

  // ── 7. Force Logout ───────────────────────────────────────────────────────

  /// POST /api/user/force-logout
  /// Revokes all tokens for the authenticated user, effectively logging
  /// them out of all devices simultaneously.
  Future<BaseResponseModel<void>> forceLogout() async {
    final raw =
        await _dio.post(endpoint: AppEndpoints.userLogout)
            as Map<String, dynamic>;

    return BaseResponseModel.fromJson(raw, (_) {});
  }
}
