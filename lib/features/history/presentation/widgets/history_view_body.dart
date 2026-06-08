import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/error/custom_failure_body.dart';
import 'package:ailixir/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:ailixir/features/history/presentation/widgets/docking_history_section.dart';
import 'package:ailixir/features/history/presentation/widgets/ligand_history_section.dart';
import 'package:ailixir/features/history/presentation/widgets/md_history_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryViewBody extends StatelessWidget {
  const HistoryViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryError) {
          return Center(
            child: CustomFailureBody(
              icon: Icons.error_outline,
              msg: state.message,
              actionLabel: 'Try Again',
              onAction: () => context.read<HistoryCubit>().loadHistory(),
            ),
          );
        }

        final isLoading = state is HistoryLoading || state is HistoryInitial;

        final ligands = state is HistoryLoaded
            ? state.ligands
            : LigandEntity.createFakeData();
        final dockings = state is HistoryLoaded
            ? state.dockings
            : DockingEntity.createFakeData();
        final mdSims = state is HistoryLoaded
            ? state.mdSimulations
            : MdEntity.createFakeData();

        return RefreshIndicator(
          onRefresh: () => context.read<HistoryCubit>().loadHistory(),
          color: AppColors.cyan400,
          backgroundColor: AppColors.slate900,
          child: Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: AppColors.cyan400,
                            size: 22.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Data History',
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Tooltip(
                            message: 'Refresh',
                            child: SizedBox(
                              width: 32.w,
                              height: 32.w,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.refresh,
                                  color: AppColors.cyan400,
                                  size: 20.sp,
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () => context
                                          .read<HistoryCubit>()
                                          .loadHistory(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Notice Banner
                  _NoticeBanner(),
                  SizedBox(height: 24.h),

                  // Ligand Generation History
                  LigandHistorySection(ligands: ligands),
                  SizedBox(height: 32.h),

                  // Docking History
                  DockingHistorySection(dockings: dockings),
                  SizedBox(height: 32.h),

                  // MD History
                  MdHistorySection(mdSimulations: mdSims),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1515),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.red700.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.red400, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Notice: Scientific data is automatically cleared after 30 days of generation. Please download important datasets for long-term storage.',
              style: AppTextStyles.bodysmall.copyWith(color: AppColors.red300),
            ),
          ),
        ],
      ),
    );
  }
}
