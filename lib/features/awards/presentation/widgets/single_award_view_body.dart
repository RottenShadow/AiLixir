import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleAwardViewBody extends StatelessWidget {
  final AwardModel award;
  final List<ScientistModel> scientists;
  const SingleAwardViewBody({
    super.key,
    required this.award,
    this.scientists = const [],
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 25.w),
        child: Column(
          spacing: 0.03.sh,
          children: [_infoCard(), _winnersHeader(), _winners()],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.white30, width: 1),
        borderRadius: BorderRadiusGeometry.all(Radius.circular(12.r)),
      ),
      color: AppColors.brandBlue.withAlpha((0.2 * 255).toInt()),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          vertical: 0.03.sh,
          horizontal: 0.02.sw,
        ),
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
    );
  }

  Widget _winnersHeader() {
    return Row(
      spacing: 13.w,
      children: [
        Icon(Icons.auto_stories_rounded, color: AppColors.awardNameGradientTop),
        Text("Prize Winners", style: AppTextStyles.h1),
      ],
    );
  }

  Widget _winners() {
    return Column(
      spacing: 0.02.sh,
      children: List.generate(scientists.length, (idx) {
        return _winnerCard(idx);
      }),
    );
  }

  Widget _winnerCard(int idx) {
    return InkWell(
      splashColor: AppColors.awardNameGradientTop,
      borderRadius: BorderRadius.circular(12.r),
      onTap: () {},
      child: Card(
        color: AppColors.brandBlue.withAlpha((0.2 * 255).toInt()),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(0.03.sw),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadiusGeometry.circular(12.r),
                child: Image.network(
                  scientists[idx].imageUrl,
                  scale: 1,
                  width: 0.1.sw,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                spacing: 0.07.sh,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(right: 0.03.sw),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(scientists[idx].name, style: AppTextStyles.h1),
                        Text(
                          scientists[idx].yearWon ?? "",
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.awardNameGradientTop,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 10.w,
                    children: [
                      Icon(
                        Icons.science,
                        color: AppColors.awardNameGradientTop,
                      ),
                      Text(
                        scientists[idx].shortBio,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.awardNameGradientTop,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      child: Row(
        spacing: 10,
        children: [
          Icon(Icons.emoji_events, size: AppTextStyles.xl.fontSize),
          Text(name, style: AppTextStyles.xl.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}
