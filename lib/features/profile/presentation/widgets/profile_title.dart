import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/profile/presentation/widgets/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0.01.sw,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadiusGeometry.circular(12.r),
          child: Image.network(
            "http://st3.depositphotos.com/1000975/12502/i/450/depositphotos_125020636-Woman-chemist-working-in-the-lab.jpg",
            fit: BoxFit.cover,
            width: 0.06.sw,
            height: 0.06.sw,
            alignment: Alignment.topLeft,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 0.015.sh,
          children: [
            Text("Dr. Jane Doe", style: AppTextStyles.small),
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
