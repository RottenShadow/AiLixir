import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.authTextSecondary.withAlpha(100)),
        borderRadius: BorderRadiusGeometry.circular(12.r),
      ),
      color: AppColors.cardBackground,
      child: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Status"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tier",
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
                Text("Free Research Tier"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "Next Refill",
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
                Text("12 days (500 Cr)"),
              ],
            ),
            LinearProgressIndicator(
              value: 650 / 1000,
              valueColor: AlwaysStoppedAnimation(AppColors.brandBlue),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Usage 650/1000 Credits this month",
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
