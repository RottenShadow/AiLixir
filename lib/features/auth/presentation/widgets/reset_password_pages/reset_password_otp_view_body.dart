import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_card_layout.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_primary_button.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

class ResetPasswordOtpViewBody extends StatefulWidget {
  final String identifier;
  const ResetPasswordOtpViewBody({super.key, required this.identifier});

  @override
  State<ResetPasswordOtpViewBody> createState() =>
      _ResetPasswordOtpViewBodyState();
}

class _ResetPasswordOtpViewBodyState extends State<ResetPasswordOtpViewBody> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 64.h,
      textStyle: AppTextStyles.h1.copyWith(
        fontSize: 24.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.authButtonBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
    );

    return AuthCardLayout(
      showBackButton: true,
      title: 'Verifying Identity',
      subtitle: 'We sent a 6-digit code to',
      footerLinkText: widget.identifier,
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Pinput(
            length: 6,
            controller: pinController,
            focusNode: focusNode,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.brandBlue, width: 2),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: AppColors.brandBlue.withValues(alpha: 0.05),
                border: Border.all(color: AppColors.brandBlue),
              ),
            ),
            onCompleted: (pin) {
              context.read<AuthCubit>().verifyPasswordOtp(
                identifier: widget.identifier,
                otp: pin,
              );
            },
          ),
          SizedBox(height: 48.h),
          AuthPrimaryButton(
            text: 'Authenticate Code',
            onPressed: () {
              if (pinController.text.length == 6) {
                context.read<AuthCubit>().verifyPasswordOtp(
                  identifier: widget.identifier,
                  otp: pinController.text,
                );
              }
            },
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Didn\'t receive the code?',
                style: AppTextStyles.bodymedium.copyWith(
                  color: AppColors.authTextSecondary,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthCubit>().forgotPassword(
                    identifier: widget.identifier,
                  );
                },
                child: Text(
                  'Resend',
                  style: AppTextStyles.bodymedium.copyWith(
                    color: AppColors.brandBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
