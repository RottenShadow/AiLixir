import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/profile/presentation/widgets/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditsIsland extends StatelessWidget {
  const CreditsIsland({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: EdgeInsetsDirectional.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            coloredLogoIcon(color: AppColors.orange700, icon: Icons.wallet),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CREDITS REMAINING",
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "2,450",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "	Cred",
                      style: AppTextStyles.labelsmall.copyWith(
                        color: AppColors.authTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 10),
            MaterialButton(
              color: AppColors.black,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10.r),
              ),
              child: Text("Add Credits"),
            ),
          ],
        ),
      ),
    );
  }
}
