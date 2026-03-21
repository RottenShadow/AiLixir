import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget awardCard(
  AwardModel award,
  BuildContext context,
  Color categoryColor,
  IconData categoryIcon,
  double paddingValue,
  void Function() onTap,
) {
  return InkWell(
    splashColor: categoryColor,
    borderRadius: BorderRadius.circular(15.r),
    onTap: onTap,
    child: Card(
      color: AppColors.brandBlue.withAlpha((0.2 * 255).toInt()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(
              left: paddingValue,
              right: paddingValue,
              top: paddingValue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _categoryIcon(categoryIcon, categoryColor),
                _categoryText(award.category, categoryColor),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(
              left: paddingValue,
              top: paddingValue,
            ),
            child: Text(award.name, style: AppTextStyles.h2),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(paddingValue),
            child: Text(
              award.shortDesc,
              style: TextStyle(color: AppColors.authTextSecondary),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _categoryText(String text, Color categoryColor) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(10.r),
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
        color: categoryColor.withAlpha((0.2 * 255).toInt()),
        child: Text(text, style: TextStyle(color: categoryColor)),
      ),
    ),
  );
}

Widget _categoryIcon(IconData icon, Color categoryColor) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(10.r),
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10),
        color: categoryColor.withAlpha((0.2 * 255).toInt()),
        child: Icon(icon, color: categoryColor),
      ),
    ),
  );
}
