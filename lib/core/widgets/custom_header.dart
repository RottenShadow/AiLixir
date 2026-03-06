import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  const CustomHeader({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            IconButton(
              onPressed: () {
                context.goBack();
              },
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: AppColors.white,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(color: AppColors.white),
            ),
            ...actions ?? [],
          ],
        ),
      ],
    );
  }
}
