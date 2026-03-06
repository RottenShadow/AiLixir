import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_gradients.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<CustomDialogAction> actions;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: actions.length == 1
          ? MainAxisAlignment.end
          : MainAxisAlignment.spaceEvenly,
      backgroundColor: AppColors.gray800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      title: Text(
        title,
        style: AppTextStyles.h6.copyWith(
          color: AppColors.rose500,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
      ),
      actions: actions
          .map((action) => _buildActionButton(context, action))
          .toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, CustomDialogAction action) {
    return CustomButton(
      onTap:
          action.onPressed ??
          () {
            if (context.mounted && context.canPop()) {
              context.goBack();
            }
          },
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(16.r),
      gradient: action.gradient ?? AppGradients.whiteLinearGradient,
      backgroundColor: action.backgroundColor,
      child: Text(
        action.text,
        style:
            action.style ??
            AppTextStyles.h6.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class CustomDialogAction {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final Gradient? gradient;
  final Color? backgroundColor;

  const CustomDialogAction({
    required this.text,
    this.onPressed,
    this.style,
    this.gradient,
    this.backgroundColor,
  });
}
