import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget coloredLogoIcon({required Color color, required IconData icon}) {
  double lightener = 0.2;
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(10.r),
    ),
    color: color.withAlpha(100),
    child: Padding(
      padding: EdgeInsetsDirectional.all(5),
      child: Icon(
        icon,
        color: color.withValues(
          alpha: color.a,
          red: color.r + lightener,
          blue: color.b + lightener,
          green: color.g + lightener,
        ),
      ),
    ),
  );
}

Widget iconLabel(
  String text,
  IconData icon, {
  Color color = AppColors.authTextSecondary,
  TextStyle? style,
  double spacing = 4,
}) {
  return Row(
    spacing: spacing,
    children: [
      Icon(icon, color: color),
      Text(text, style: style),
    ],
  );
}

Widget subscriptionCard() {
  return Card(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(10.r),
        gradient: LinearGradient(
          colors: [AppColors.black, AppColors.brandBlue, AppColors.blue800],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Text("Upgrade For", style: AppTextStyles.small),
            iconLabel(
              "Priority Gpu Access",
              Icons.check_circle_outline,
              color: AppColors.sky300,
              style: AppTextStyles.labellarge,
            ),
            iconLabel(
              "Priority Gpu Access",
              Icons.check_circle_outline,
              color: AppColors.sky300,
              style: AppTextStyles.labellarge,
            ),
            iconLabel(
              "Priority Gpu Access",
              Icons.check_circle_outline,
              color: AppColors.sky300,
              style: AppTextStyles.labellarge,
            ),
            MaterialButton(
              onPressed: () {},
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12.r),
              ),
              child: Text(
                "Subscribe to Premium",
                style: AppTextStyles.labellarge.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Billed Annually • Save 20%",
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.authTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
