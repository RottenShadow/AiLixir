import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/profile/presentation/widgets/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.iconColor,
    required this.icon,
    required this.infoTitle,
    required this.data,
    required this.footnote,
  });
  final Color iconColor;
  final IconData icon;
  final String infoTitle;
  final int data;
  final String footnote;
  @override
  Widget build(BuildContext context) {
    bool isPositive = footnote.contains("+");
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.authTextSecondary.withAlpha(100)),
        borderRadius: BorderRadiusGeometry.circular(12.r),
      ),
      color: AppColors.cardBackground,
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(20, 20, 60, 20),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            coloredLogoIcon(color: iconColor, icon: icon),
            Text(
              infoTitle,
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.authTextSecondary,
              ),
            ),
            Text("$data", style: AppTextStyles.medium),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.moving : Icons.east,
                  color: isPositive
                      ? AppColors.green400
                      : AppColors.authTextSecondary,
                ),
                Text(
                  footnote,
                  style: AppTextStyles.labelsmall.copyWith(
                    color: isPositive
                        ? AppColors.green400
                        : AppColors.authTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
