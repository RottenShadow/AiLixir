import 'package:ailixir/core/entities/drug_repurposing_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/features/history/presentation/cubits/drug_repurposing_cubit/drug_repurposing_cubit.dart';

import 'package:ailixir/features/history/presentation/views/drug_repurposing_job_detail_view.dart';
import 'package:ailixir/features/history/presentation/views/drug_repurposing_see_all_view.dart';
import 'package:ailixir/features/history/presentation/widgets/drug_repurposing_sub_tab_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DrugRepurposingHistorySection extends StatelessWidget {
  const DrugRepurposingHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugRepurposingCubit, DrugRepurposingState>(
      builder: (context, state) {
        if (state is DrugRepurposingLoaded) {
          final items = state.selectedSubTab == DrugRepurposingSubTab.targets
              ? state.targets
              : state.screen;
          final isEmpty = items.isEmpty;

          return Column(
            mainAxisSize: isEmpty ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state),
              SizedBox(height: 12.h),
              DrugRepurposingSubTabSelector(
                selected: state.selectedSubTab,
                onChanged: (tab) => context.read<DrugRepurposingCubit>().selectSubTab(tab),
              ),
              SizedBox(height: 12.h),
              if (isEmpty)
                Expanded(
                  child: Center(
                    child: CustomEmptyBody(
                      icon: Icons.biotech_outlined,
                      title: 'No History Yet',
                      subTitle: 'Drug repurposing jobs will appear here.',
                    ),
                  ),
                )
              else
                ...items.take(5).map(
                  (e) => _RepurposingCard(entity: e),
                ),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state),
            SizedBox(height: 12.h),
              if (state is DrugRepurposingLoading)
              Skeletonizer(
                enabled: true,
                child: Column(
                  children: DrugRepurposingEntity.createFakeData()
                      .map((e) => _RepurposingCard(entity: e))
                      .toList(),
                ),
              )
            else if (state is DrugRepurposingError)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Text(state.message, style: AppTextStyles.bodysmall.copyWith(color: AppColors.red400)),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DrugRepurposingState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.biotech_outlined, color: AppColors.cyan400, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Drug Repurposing History',
              style: AppTextStyles.h3.copyWith(color: AppColors.white),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            final subTab = state is DrugRepurposingLoaded
                ? state.selectedSubTab
                : DrugRepurposingSubTab.targets;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => DrugRepurposingCubit()..loadAll(
                    subTab == DrugRepurposingSubTab.targets
                        ? DrugRepurposingType.targets
                        : DrugRepurposingType.screen,
                  ),
                  child: const DrugRepurposingSeeAllView(),
                ),
              ),
            );
          },
          child: Text(
            'See All',
            style: AppTextStyles.labelsmall.copyWith(color: AppColors.cyan400),
          ),
        ),
      ],
    );
  }
}

class _RepurposingCard extends StatelessWidget {
  final DrugRepurposingEntity entity;

  const _RepurposingCard({required this.entity});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy').format(entity.createdAt);
    final isTargets = entity.type == DrugRepurposingType.targets;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.slate700,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              isTargets ? Icons.ads_click : Icons.screen_search_desktop_outlined,
              size: 18.sp,
              color: AppColors.cyan400,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job #${entity.id}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.slate400),
                ),
                SizedBox(height: 2.h),
                Text(
                  entity.diseaseName,
                  style: AppTextStyles.h6.copyWith(color: AppColors.white),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$dateStr · ${entity.resultCount} ${isTargets ? 'targets' : 'candidates'}',
                  style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DrugRepurposingJobDetailView(job: entity),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.cyan400.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Details',
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.cyan400,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward_ios, size: 10.sp, color: AppColors.cyan400),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _StatusBadge(status: entity.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == 'completed';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (isCompleted ? AppColors.emerald900 : AppColors.red900).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        isCompleted ? 'COMPLETED' : 'FAILED',
        style: AppTextStyles.labelsmall.copyWith(
          color: isCompleted ? AppColors.emerald400 : AppColors.red400,
        ),
      ),
    );
  }
}
