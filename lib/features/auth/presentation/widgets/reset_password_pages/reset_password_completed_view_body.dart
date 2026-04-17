import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_card_layout.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_primary_button.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class ResetPasswordCompletedViewBody extends StatelessWidget {
  const ResetPasswordCompletedViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      showBackButton: true,
      title: 'Update Successful',
      subtitle: 'Your research identity has been re-secured',
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.greenAccent,
              size: 64.sp,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'Your password has been successfully updated. You may now return to the laboratory platform.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodymedium.copyWith(
              color: AppColors.authTextSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 48.h),
          AuthPrimaryButton(
            text: 'Return to Login',
            onPressed: () => context.navigateReplacementTo(LoginView.routeName),
          ),
        ],
      ),
    );
  }
}
