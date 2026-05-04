part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthShowToastState extends AuthState {
  final String msg;
  AuthShowToastState({required this.msg});
}

final class AuthSuccess extends AuthShowToastState {
  AuthSuccess({required super.msg});
}

final class AuthError extends AuthShowToastState {
  AuthError({required super.msg});
}

final class AuthEmailUnverifiedState extends AuthError {
  final String email;
  AuthEmailUnverifiedState({required this.email, required super.msg});
}

final class AuthResetVerifyLoginOtpState extends AuthShowToastState {
  AuthResetVerifyLoginOtpState({required super.msg});
}

final class AuthForgotPasswordState extends AuthShowToastState {
  final String email;
  AuthForgotPasswordState({required this.email, required super.msg});
}

final class AuthVerifyPasswordOtp extends AuthShowToastState {
  final String email;
  AuthVerifyPasswordOtp({required this.email, required super.msg});
}

final class AuthVerifyPasswordCompleted extends AuthShowToastState {
  AuthVerifyPasswordCompleted({required super.msg});
}

final class AuthForceLogout extends AuthShowToastState {
  AuthForceLogout({required super.msg});
}
