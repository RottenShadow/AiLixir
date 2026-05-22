import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/profile/presentation/widgets/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTitle extends StatelessWidget {
  final String username;
  const ProfileTitle({super.key, this.username = "Jane Doe"});
  @override
  Widget build(BuildContext context) {
    String secondChar = username.split(" ").last[0];
    return Row(
      spacing: 0.01.sw,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadiusGeometry.circular(12.r),
          child: Container(
            color: AppColors.brandBlue,
            width: 0.06.sw,
            height: 0.06.sw,
            alignment: Alignment.center,
            child: Text("${username[0]}$secondChar", style: AppTextStyles.xl),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 0.015.sh,
          children: [
            Text(username, style: AppTextStyles.small),
            iconLabel(
              "Stanford University • Senior Biologist",
              Icons.school_outlined,
              color: AppColors.authTextSecondary,
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.authTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
