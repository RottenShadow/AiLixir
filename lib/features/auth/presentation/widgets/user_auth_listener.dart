import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/views/join_view.dart';
import 'package:ailixir/features/auth/presentation/views/reset_password_otp_view.dart';
import 'package:ailixir/features/auth/presentation/views/verify_email_view.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/features/main/presentation/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAuthListener extends StatelessWidget {
  final Widget child;
  const UserAuthListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    /// Must be placed in the root of the auth views, ONLY ONCE!!
    return BlocListener<UserAuthCubit, UserAuthState>(
      listener: (context, state) {
        if (state is UserAuthError) {
          AppToast.showErrorToast(context: context, message: state.message);
        } else if (state is UserAuthSuccess) {
          context.navigateAndClearStack(MainView.routeName);
        } else if (state is UserAuthRegisteredNotVerified) {
          context.navigateTo(VerifyEmailView.routeName, arguments: state.email);
        } else if (state is UserAuthForgotPasswordOtpSent) {
          context.navigateTo(
            ResetPasswordOtpView.routeName,
            arguments: state.email,
          );
        } else if (state is UserAuthResendSuccess) {
          AppToast.showSuccessToast(context: context, message: state.message);
        } else if (state is UserAuthResetPasswordSuccess) {
          AppToast.showSuccessToast(context: context, message: state.message);
          context.navigateTo(LoginView.routeName);
        } else if (state is UserAuthForceLogout) {
          AppToast.showErrorToast(context: context, message: state.msg);
          context.navigateAndClearStack(JoinView.routeName);
        }
      },

      child: child,
    );
  }
}
