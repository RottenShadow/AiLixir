import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:ailixir/features/auth/data/model/auth/auth_token_user_response.dart';
import 'package:ailixir/features/auth/data/model/user/user_model.dart';
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
  }) {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeLogin(email: email);
    }
    return safeApiCall(() async {
      final res = await _api.login(email: email, password: password);
      if (res.data != null) {
        await _persistSession(res.data!);
      }
      return res.message;
    });
  }

  // ── 2. Register ───────────────────────────────────────────────────────────

  /// Returns the email address so the caller can route to OTP verification.
  Future<Either<Failure, String>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeRegister(email: email);
    }
    return safeApiCall(() async {
      final res = await _api.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      // Return the email so the UI can pre-fill the verify screen.
      return res.data?.email ?? email;
    });
  }

  // ── 3. Verify Email ───────────────────────────────────────────────────────

  Future<Either<Failure, String>> verifyEmail({
    required String email,
    required String otp,
  }) {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeVerifyEmail(email: email);
    }
    return safeApiCall(() async {
      final res = await _api.verifyEmail(email: email, otp: otp);
      if (res.data != null) {
        await _persistSession(res.data!);
      }
      return res.message;
    });
  }

  // ── 4. Forgot Password ────────────────────────────────────────────────────

  /// Returns the email so the UI can route to the OTP entry screen.
  Future<Either<Failure, String>> forgotPassword({required String email}) {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeForgotPassword(email: email);
    }
    return safeApiCall(() async {
      final res = await _api.forgotPassword(email: email);
      return res.data?.email ?? email;
    });
  }

  // ── 5. Reset Password ─────────────────────────────────────────────────────

  /// Resets the user's password using the OTP received by email.
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeResetPassword();
    }
    return safeApiCall(() async {
      final res = await _api.resetPassword(
        email: email,
        otp: otp,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return res.message;
    });
  }

  // ── 6. Resend Verification ────────────────────────────────────────────────

  Future<Either<Failure, String>> resendVerification({required String email}) {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeResendVerification(email: email);
    }
    return safeApiCall(() async {
      final res = await _api.resendVerification(email: email);
      return res.message;
    });
  }

  // ── 7. Force Logout ────────────────────────────────────────────────

  Future<Either<Failure, String>> forceLogout() {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeForceLogout();
    }
    return safeApiCall(() async {
      final res = await _api.forceLogout();
      return res.message;
    });
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Stores the token in [FlutterSecureStorage] and caches user data in
  /// [SharedPreferences] via the existing [LocalAuthDataSource].
  Future<void> _persistSession(AuthTokenUserResponse data) async {
    await _local.saveAllUserData(authTokenUserResponse: data);
    log('Session persisted for ${data.user.email}');
  }

  // ── Fake helpers ──────────────────────────────────────────────────────────

  Future<Either<Failure, String>> _fakeLogin({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 33));
    await _persistSession(_fakeSession(email: email));
    return const Right("Login successful");
  }

  Future<Either<Failure, String>> _fakeRegister({
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 33));
    return Right(email);
  }

  Future<Either<Failure, String>> _fakeVerifyEmail({
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 33));
    await _persistSession(_fakeSession(email: email));
    return const Right("Email verified");
  }

  Future<Either<Failure, String>> _fakeForgotPassword({
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 33));
    return Right(email);
  }

  Future<Either<Failure, String>> _fakeResetPassword() async {
    await Future.delayed(const Duration(milliseconds: 33));
    return const Right("Password reset successfully");
  }

  Future<Either<Failure, String>> _fakeResendVerification({
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 33));
    return const Right("Verification email sent");
  }

  Future<Either<Failure, String>> _fakeForceLogout() async {
    await Future.delayed(const Duration(milliseconds: 33));
    return const Right("Logged out");
  }

  AuthTokenUserResponse _fakeSession({required String email}) {
    return AuthTokenUserResponse(
      token: 'fake-jwt-token',
      user: UserModel(
        id: 1,
        name: 'Test User',
        email: email,
        role: 'normal',
        avatar: '',
        updatedAt: '',
        isVerified: true,
      ),
    );
  }
}
