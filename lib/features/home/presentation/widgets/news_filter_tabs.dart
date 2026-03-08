import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/home/domain/entities/news_filter.dart';

class NewsFilterTabs extends StatelessWidget {
  final List<NewsFilter> filters;
  final String selectedId;
  final ValueChanged<String> onFilterSelected;

  const NewsFilterTabs({
    super.key,
    required this.filters,
    required this.selectedId,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final active = filter.id == selectedId;
          return GestureDetector(
            onTap: () => onFilterSelected(filter.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.brandBlue.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: active
                      ? AppColors.brandBlue.withOpacity(0.5)
                      : Colors.transparent,
                ),
              ),
              child: Text(
                filter.label,
                style: AppTextStyles.bodysmall.copyWith(
                  color: active
                      ? AppColors.brandBlue
                      : AppColors.authTextSecondary,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
