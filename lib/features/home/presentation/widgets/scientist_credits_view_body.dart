import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScientistCreditsViewBody extends StatelessWidget {
  const ScientistCreditsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: 0.1.sw,
          vertical: 0.1.sh,
        ),
        alignment: Alignment.center,
        child: Row(
          spacing: 0.1.sw,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_scientistCard(), _scientistCard()],
        ),
      ),
    );
  }

  static const String _defaultAchievement =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Widget _scientistImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(12.r),
      child: Image.network(
        image,
        width: 0.4.sw,
        fit: BoxFit.contain,
        alignment: Alignment.topLeft,
      ),
    );
  }

  Widget _scientistCard({
    String scientistName = "DEFAULT_SCIENTIST_NAME",
    String scientistWork = _defaultAchievement,
    String scientistImage =
        "https://media.gettyimages.com/id/57520719/photo/doctor-holding-note-pad-posing-in-studio-portrait.jpg?s=612x612&w=0&k=20&c=cxnjilkTFucKBOneZYY6xZY7sEWTLvKLXzyWRgjJCqE=",
  }) {
    return SizedBox(
      width: 0.8.sw,
      child: Card(
        color: AppColors.brandBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12.r),
          side: BorderSide(color: AppColors.brandBorder, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 0,
          children: [
            _scientistImage(scientistImage),
            SizedBox(
              width: 0.35.sw,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(scientistName, style: AppTextStyles.h1),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.brandBorder),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Their Achievements',
                          style: AppTextStyles.labelsmall.copyWith(
                            color: AppColors.authTextSecondary.withValues(
                              alpha: 0.5,
                            ),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.brandBorder),
                      ),
                    ],
                  ),
                  Text(scientistWork, style: AppTextStyles.bodymedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
