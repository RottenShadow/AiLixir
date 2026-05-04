import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/history/presentation/cubits/see_all_cubit/see_all_cubit.dart';
import 'package:ailixir/features/history/presentation/views/md_see_all_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MdHistorySection extends StatelessWidget {
  final List<MdEntity> mdSimulations;
  const MdHistorySection({super.key, required this.mdSimulations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.blur_on, color: AppColors.purple400, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Molecular Dynamics History',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => MdSeeAllCubit()..loadFirstPage(),
                      child: const MdSeeAllView(),
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.slate800,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.brandBorder),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Simulation Task',
                        style: AppTextStyles.labelsmall.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Forcefield',
                        style: AppTextStyles.labelsmall.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Duration',
                        style: AppTextStyles.labelsmall.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Status',
                        style: AppTextStyles.labelsmall.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Artifacts',
                        style: AppTextStyles.labelsmall.copyWith(
                          color: AppColors.slate500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.brandBorder, height: 1),
              ...mdSimulations.map((md) => _MdRow(md: md)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MdRow extends StatelessWidget {
  final MdEntity md;
  const _MdRow({required this.md});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy · hh:mm a').format(md.createdAt);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  md.simulationTask,
                  style: AppTextStyles.bodysmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  dateStr,
                  style: AppTextStyles.bodyxs.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              md.forcefield,
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.slate300,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              md.duration,
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.slate300,
              ),
            ),
          ),
          Expanded(flex: 2, child: _StatusBadge(status: md.status)),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ArtifactBtn(label: '.PDB'),
                SizedBox(width: 6.w),
                _ArtifactBtn(label: '.DCD'),
                SizedBox(width: 6.w),
                _ArtifactBtn(label: '.LOG'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MdStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case MdStatus.completed:
        bg = AppColors.emerald900.withValues(alpha: 0.5);
        text = AppColors.emerald400;
        label = 'COMPLETED';
      case MdStatus.running:
        bg = AppColors.blue900.withValues(alpha: 0.5);
        text = AppColors.blue400;
        label = 'RUNNING';
      case MdStatus.failed:
        bg = AppColors.red900.withValues(alpha: 0.5);
        text = AppColors.red400;
        label = 'FAILED';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(label, style: AppTextStyles.labelsmall.copyWith(color: text)),
    );
  }
}

class _ArtifactBtn extends StatelessWidget {
  final String label;
  const _ArtifactBtn({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        label,
        style: AppTextStyles.labelsmall.copyWith(color: AppColors.slate400),
      ),
    );
  }
}
