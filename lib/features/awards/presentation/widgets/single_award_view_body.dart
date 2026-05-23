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
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: 0.05.sw,
        vertical: 0.03.sh,
      ),
      child: Column(spacing: 0.03.sh, children: [_winners()]),
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
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 2.6 / 1.777,
        shrinkWrap: true,
        children: List.generate(scientists.length, (idx) {
          return _winnerCard(idx);
        }),
      ),
    );
  }

  Widget _winnerCard(int idx) {
    return InkWell(
      splashColor: AppColors.awardNameGradientTop,
      borderRadius: BorderRadius.circular(12.r),
      onTap: () {},
      child: Card(
        color: AppColors.brandBlue.withAlpha((0.2 * 255).toInt()),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(
                      0.03.sw,
                      0.03.sw,
                      0.01.sw,
                      0.03.sw,
                    ),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadiusGeometry.circular(12.r),
                      child: Image.network(
                        scientists[idx].imageUrl,
                        scale: 1,
                        width: 0.08.sw,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scientists[idx].name, style: AppTextStyles.bodyxl),
                    Text(
                      scientists[idx].yearWon ?? "",
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.awardNameGradientTop,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 0.01.sw),
                Icon(Icons.science, color: AppColors.awardNameGradientTop),
                Text(
                  scientists[idx].shortBio,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.awardNameGradientTop,
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
