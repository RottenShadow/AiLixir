import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/core/widgets/file_download_view.dart';
import 'package:ailixir/features/history/presentation/cubits/docking_history_cubit/docking_history_cubit.dart';
import 'package:ailixir/features/history/presentation/views/docking_see_all_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DockingHistorySection extends StatelessWidget {
  final List<DockingEntity> dockings;
  const DockingHistorySection({super.key, required this.dockings});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: dockings.isEmpty ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.hub_outlined, color: AppColors.cyan400, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Docking History',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => DockingHistoryCubit()..loadAll(),
                      child: const DockingSeeAllView(),
                    ),
                  ),
                );
              },
              child: Text(
                'See All',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.cyan400,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (dockings.isEmpty)
          Expanded(
            child: Center(
              child: CustomEmptyBody(
                icon: Icons.hub_outlined,
                title: 'No Docking Results',
                subTitle: 'Docking simulation results will appear here.',
              ),
            ),
          )
        else
          Row(
            children: dockings
                .map(
                  (d) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: d == dockings.last ? 0 : 10.w,
                      ),
                      child: _DockingCard(docking: d),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _DockingCard extends StatelessWidget {
  final DockingEntity docking;
  const _DockingCard({required this.docking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(10.r),
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
                  'Target: ${docking.targetId} (${docking.targetName})',
                  style: AppTextStyles.h6.copyWith(color: AppColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Job ID: ${docking.jobId}',
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
          ),
          SizedBox(height: 12.h),
          _StatItem(
            label: 'Best Affinity',
            value: '${docking.vinaScore.toStringAsFixed(3)} kcal/mol',
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                '${docking.scores.length} poses',
                style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
              ),
              const Spacer(),
              GestureDetector(
                onTap: docking.downloadUrl != null
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              FileDownloadView(url: docking.downloadUrl!),
                        ),
                      )
                    : null,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: docking.downloadUrl != null
                        ? AppColors.slate700
                        : AppColors.slate800,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.download_outlined,
                    color: docking.downloadUrl != null
                        ? AppColors.slate300
                        : AppColors.slate600,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
        ),
        SizedBox(height: 4.h),
        Text(value, style: AppTextStyles.h4.copyWith(color: AppColors.cyan400)),
      ],
    );
  }
}
