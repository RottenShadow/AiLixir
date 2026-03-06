import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class CustomFailureBody extends StatelessWidget {
  final String msg;
  const CustomFailureBody({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oops! Something went wrong.',
            textAlign: TextAlign.center,
            style: AppTextStyles.h4,
          ),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodylarge.copyWith(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}
