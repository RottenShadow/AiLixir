import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:ailixir/features/auth/data/repos/social_auth_repo_impl.dart';
import 'package:ailixir/features/auth/data/repos/auth_repo_impl.dart';
import 'package:get_it/get_it.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final AuthRepoImpl _repo = GetIt.I.get<AuthRepoImpl>();
  final _socialRepo = GetIt.I.get<SocialAuthRepoImpl>();
  final _local = GetIt.I.get<LocalAuthDataSource>();

  UserAuthCubit() : super(UserAuthInitial());

  // ── Sign In With Google ──────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(UserAuthLoading());
    var res = await _socialRepo.signInWithGoogle();

    res.fold((f) {
      emit(UserAuthError(message: f.message));
      // emit(UserAuthSuccess());
    }, (msg) => emit(UserAuthSuccess()));
  }

  // ── Force Logout ─────────────────────────────────────────────────────────

  Future<void> forceLogout() async {
    log('shdw: AuthLogout');
    emit(UserAuthLoading());
    await _repo.forceLogout();
    await _local.clearUserTokensAndData();
    emit(UserAuthForceLogout());
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  Future<void> login({required String email, required String password}) async {
    emit(UserAuthLoading());
    final res = await _repo.login(email: email, password: password);
    res.fold((f) {
      if (f.message.contains('Email not verified')) {
        emit(UserAuthRegisteredNotVerified(email: email));
      } else {
        emit(UserAuthError(message: f.message));
      }
    }, (_) => emit(UserAuthSuccess()));
  }

  // ── Register ──────────────────────────────────────────────────────────────

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(UserAuthLoading());
    final res = await _repo.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    res.fold(
      (f) => emit(UserAuthError(message: f.message)),
      // res.data is the email returned by the API
      (email) => emit(UserAuthRegisteredNotVerified(email: email)),
    );
  }

  // ── Verify Email ──────────────────────────────────────────────────────────

  Future<void> verifyEmail({required String email, required String otp}) async {
    emit(UserAuthLoading());
    final res = await _repo.verifyEmail(email: email, otp: otp);
    res.fold(
      (f) => emit(UserAuthError(message: f.message)),
      (_) => emit(UserAuthSuccess()),
    );
  }

  // ── Forgot Password ───────────────────────────────────────────────────────

  Future<void> forgotPassword({required String email}) async {
    emit(UserAuthLoading());
    final res = await _repo.forgotPassword(email: email);
    res.fold(
      (f) => emit(UserAuthError(message: f.message)),
      (email) => emit(UserAuthForgotPasswordOtpSent(email: email)),
    );
  }

  // ── Reset Password ────────────────────────────────────────────────────────

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(UserAuthLoading());
    final res = await _repo.resetPassword(
      email: email,
      otp: otp,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    res.fold(
      (f) => emit(UserAuthError(message: f.message)),
      (msg) => emit(UserAuthResetPasswordSuccess(message: msg)),
    );
  }

  // ── Resend Verification ───────────────────────────────────────────────────

  Future<void> resendVerification({required String email}) async {
    emit(UserAuthLoading());
    final res = await _repo.resendVerification(email: email);
    res.fold(
      (f) => emit(UserAuthError(message: f.message)),
      (msg) => emit(UserAuthResendSuccess(message: msg)),
    );
  }
}
