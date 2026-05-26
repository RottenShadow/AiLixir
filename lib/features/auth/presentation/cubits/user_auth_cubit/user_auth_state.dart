part of 'user_auth_cubit.dart';

@immutable
sealed class UserAuthState {}

final class UserAuthInitial extends UserAuthState {}

final class UserAuthLoading extends UserAuthState {}

final class UserAuthError extends UserAuthState {
  final String message;
  UserAuthError({required this.message});
}

/// Login succeeded — token is stored, navigate to home.
final class UserAuthSuccess extends UserAuthState {
  final String msg;
  UserAuthSuccess({this.msg = 'Logged in Successfully!'});
}

/// Register succeeded — navigate to OTP verify screen with [email].
final class UserAuthRegisteredNotVerified extends UserAuthState {
  final String email;
  UserAuthRegisteredNotVerified({required this.email});
}

/// Forgot-password OTP sent — navigate to OTP entry screen with [email].
final class UserAuthForgotPasswordOtpSent extends UserAuthState {
  final String email;
  UserAuthForgotPasswordOtpSent({required this.email});
}

/// Resend verification succeeded.
final class UserAuthResendSuccess extends UserAuthState {
  final String message;
  UserAuthResendSuccess({required this.message});
}

/// Password reset succeeded — navigate to login.
final class UserAuthResetPasswordSuccess extends UserAuthState {
  final String message;
  UserAuthResetPasswordSuccess({required this.message});
}

/// Force logout succeeded — navigate to join.
final class UserAuthForceLogout extends UserAuthState {
  final String msg;
  UserAuthForceLogout({this.msg = 'Logged out Successfully!'});
}
