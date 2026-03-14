import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleAwardViewBody extends StatelessWidget {
  final AwardModel award;
  const SingleAwardViewBody({super.key, required this.award});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [_infoCard(), _winnersHeader(), _winners()]),
    );
  }

  Widget _infoCard() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25.w),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.brandBorder, width: 2),
          borderRadius: BorderRadiusGeometry.all(Radius.circular(12.r)),
        ),
        color: AppColors.brandBlue.withAlpha((0.2 * 255).toInt()),
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 10.w),
          child: Column(
            spacing: 50.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(award.name),
              Text(award.shortDesc),
              Row(children: [Text(award.category)]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _winnersHeader() {
    return Row();
  }

  Widget _winners() {
    return Column();
  }

  Widget _winnerCard() {
    return Card();
  }

  Widget _title(String name) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            AppColors.awardNameGradientTop,
            AppColors.awardNameGradientBottom,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: Text(
        name,
        style: AppTextStyles.xl.copyWith(color: AppColors.white),
      ),
    );
  }
}
