import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DockingResultsPanel extends StatelessWidget {
  final List<DockingEntity> results;
  const DockingResultsPanel({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.hub_outlined, color: AppColors.cyan400, size: 16.sp),
            SizedBox(width: 6.w),
            Text('Docking Results',
                style: AppTextStyles.h5.copyWith(color: AppColors.white)),
          ],
        ),
        SizedBox(height: 10.h),
        ...results.map((r) => _DockingResultCard(result: r)),
      ],
    );
  }
}

class _DockingResultCard extends StatelessWidget {
  final DockingEntity result;
  const _DockingResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Target: ${result.targetId} (${result.targetName})',
                  style: AppTextStyles.h6.copyWith(color: AppColors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.download_outlined,
                  color: AppColors.slate400, size: 16.sp),
            ],
          ),
          SizedBox(height: 4.h),
          Text('Job: ${result.jobId}',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500)),
          SizedBox(height: 8.h),
          Row(
            children: [
              _Stat('Vina Score', result.vinaScore.toString()),
              SizedBox(width: 16.w),
              _Stat('H-Bonds', result.hydrogenBonds.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400)),
        Text(value,
            style: AppTextStyles.h5.copyWith(color: AppColors.cyan400)),
      ],
    );
  }
}
