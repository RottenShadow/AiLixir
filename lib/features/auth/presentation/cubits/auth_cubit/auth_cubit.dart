import 'dart:developer';
import 'package:ailixir/core/errors/api/api_email_unverified.dart';
import 'package:ailixir/features/auth/data/model/signup_input_details_model.dart';
import 'package:ailixir/features/auth/data/repos/auth_repo_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/features/auth/data/repos/social_auth_repo_impl.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final _auth = GetIt.I.get<AuthRepoImpl>();
  final _socialAuth = GetIt.I.get<SocialAuthRepoImpl>();
  AuthCubit() : super(AuthInitial());

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    var res = await _socialAuth.signInWithGoogle();

    res.fold((f) {
      emit(AuthSuccess(msg: f.message));
    }, (msg) => emit(AuthSuccess(msg: msg)));
  }

  Future<void> forceLogout() async {
    log('testAuthLogout');
    emit(AuthLoading());
    var msg = await _socialAuth.forceLogout();
    // await _resetLazySingletons();
    emit(AuthForceLogout(msg: msg));
  }

  Future<void> createAccount({
    required SignupInputDetailsModel signupInputDetailsModel,
  }) async {
    emit(AuthLoading());
    var res = await _auth.signUpWithEmailAndPassword(
      signupInputDetailsModel: signupInputDetailsModel,
    );

    res.fold((f) {
      emit(AuthError(msg: f.message));
    }, (msg) => emit(AuthSuccess(msg: msg)));
  }

  Future<void> loginWithPassword({
    required String identifier,
    required String password,
  }) async {
    emit(AuthLoading());
    var res = await _auth.loginWithPassword(
      identifier: identifier,
      password: password,
    );

    res.fold((f) {
      if (f is AuthEmailUnverified) {
        return emit(AuthEmailUnverifiedState(email: f.email, msg: f.message));
      }
      return emit(AuthError(msg: f.message));
    }, (msg) => emit(AuthSuccess(msg: msg)));
  }

  Future<void> completeLogin({
    required String identifier,
    required String otp,
  }) async {
    emit(AuthLoading());
    var res = await _auth.completeLogin(identifier: identifier, otp: otp);

    res.fold((f) {
      return emit(AuthError(msg: f.message));
    }, (msg) => emit(AuthSuccess(msg: msg)));
  }

  Future<void> resendVerifyLoginOtp({required String identifier}) async {
    emit(AuthLoading());
    var res = await _auth.resendVerificationOtp(identifier: identifier);

    res.fold((f) {
      return emit(AuthError(msg: f.message));
    }, (msg) => emit(AuthResetVerifyLoginOtpState(msg: msg)));
  }

  Future<void> forgotPassword({required String identifier}) async {
    emit(AuthLoading());
    var res = await _auth.forgotPassword(identifier: identifier);

    res.fold((f) {
      return emit(AuthError(msg: f.message));
    }, (msg) => emit(AuthForgotPasswordState(email: identifier, msg: msg)));
  }

  Future<void> verifyPasswordOtp({
    required String identifier,
    required String otp,
  }) async {
    emit(AuthLoading());
    var res = await _auth.verifyPasswordOtp(identifier: identifier, otp: otp);

    res.fold((f) {
      return emit(AuthError(msg: f.message));
    }, (msg) => emit(AuthVerifyPasswordOtp(email: identifier, msg: msg)));
  }

  Future<void> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    var res = await _auth.resetPassword(
      password: password,
      confirmPassword: confirmPassword,
    );

    res.fold((f) {
      return emit(AuthError(msg: f.message));
    }, (msg) => emit(AuthVerifyPasswordCompleted(msg: msg)));
  }
}
