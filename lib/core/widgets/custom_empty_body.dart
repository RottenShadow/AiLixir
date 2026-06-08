import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class CustomEmptyBody extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  const CustomEmptyBody({
    super.key,
    required this.title,
    required this.subTitle,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Icon(icon, size: 48, color: AppColors.gray500),
            ),
          Text(title, textAlign: TextAlign.center, style: AppTextStyles.h4),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodylarge.copyWith(color: AppColors.gray500),
            ),
          ),
          if (onAction != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: CustomButton(
                onTap: onAction,
                text: actionLabel ?? 'Refresh',
                icon: Icons.refresh_outlined,
                showIcon: true,
              ),
            ),
        ],
      ),
    );
  }
}
