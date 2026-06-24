import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/error/custom_failure_body.dart';
import 'package:ailixir/features/history/presentation/cubits/docking_history_cubit/docking_history_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/drug_repurposing_cubit/drug_repurposing_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/generation_history_cubit/generation_history_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/history_tab_cubit/history_tab_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/md_history_cubit/md_history_cubit.dart';
import 'package:ailixir/features/history/presentation/widgets/docking_history_section.dart';
import 'package:ailixir/features/history/presentation/widgets/drug_repurposing_history_section.dart';
import 'package:ailixir/features/history/presentation/widgets/history_tab_selector.dart';
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
    return BlocBuilder<HistoryTabCubit, HistoryTabState>(
      builder: (context, tabState) {
        final selectedTab = tabState.selectedTab;

        return LayoutBuilder(
          builder: (context, constraints) {
            return RefreshIndicator(
              onRefresh: () => _refreshCurrentTab(context, selectedTab),
              color: AppColors.cyan400,
              backgroundColor: AppColors.slate900,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Header(),
                          SizedBox(height: 20.h),
                          _NoticeBanner(),
                          SizedBox(height: 20.h),
                          HistoryTabSelector(),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _buildContent(context, selectedTab),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HistoryTab selectedTab) {
    switch (selectedTab) {
      case HistoryTab.generation:
        return BlocBuilder<GenerationHistoryCubit, GenerationHistoryState>(
          builder: (context, state) {
            return switch (state) {
              GenerationHistoryLoading() || GenerationHistoryInitial() => Skeletonizer(
                  enabled: true,
                  child: LigandHistorySection(ligands: LigandEntity.createFakeData()),
                ),
              GenerationHistoryLoaded(:final ligands) => LigandHistorySection(ligands: ligands),
              GenerationHistoryLoadingMore(:final ligands) =>
                  LigandHistorySection(ligands: ligands),
              GenerationHistoryError(:final message) => _ErrorSection(message: message),
            };
          },
        );

      case HistoryTab.docking:
        return BlocBuilder<DockingHistoryCubit, DockingHistoryState>(
          builder: (context, state) {
            return switch (state) {
              DockingHistoryLoading() || DockingHistoryInitial() => Skeletonizer(
                  enabled: true,
                  child: DockingHistorySection(dockings: DockingEntity.createFakeData()),
                ),
              DockingHistoryLoaded(:final dockings) => DockingHistorySection(dockings: dockings),
              DockingHistoryLoadingMore(:final dockings) =>
                  DockingHistorySection(dockings: dockings),
              DockingHistoryError(:final message) => _ErrorSection(message: message),
            };
          },
        );

      case HistoryTab.md:
        return BlocBuilder<MdHistoryCubit, MdHistoryState>(
          builder: (context, state) {
            return switch (state) {
              MdHistoryLoading() || MdHistoryInitial() => Skeletonizer(
                  enabled: true,
                  child: MdHistorySection(mdSimulations: MdEntity.createFakeData()),
                ),
              MdHistoryLoaded(:final mdSimulations) =>
                  MdHistorySection(mdSimulations: mdSimulations),
              MdHistoryLoadingMore(:final mdSimulations) =>
                  MdHistorySection(mdSimulations: mdSimulations),
              MdHistoryError(:final message) => _ErrorSection(message: message),
            };
          },
        );

      case HistoryTab.drugRepurposing:
        return const DrugRepurposingHistorySection();
    }
  }

  Future<void> _refreshCurrentTab(BuildContext context, HistoryTab tab) async {
    switch (tab) {
      case HistoryTab.generation:
        return context.read<GenerationHistoryCubit>().load();
      case HistoryTab.docking:
        return context.read<DockingHistoryCubit>().load();
      case HistoryTab.md:
        return context.read<MdHistoryCubit>().load();
      case HistoryTab.drugRepurposing:
        return context.read<DrugRepurposingCubit>().load();
    }
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryTabCubit, HistoryTabState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: AppColors.cyan400, size: 22.sp),
                SizedBox(width: 10.w),
                Text(
                  'Data History',
                  style: AppTextStyles.h2.copyWith(color: AppColors.white),
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
                      icon: Icon(Icons.refresh, color: AppColors.cyan400, size: 20.sp),
                      onPressed: () => _refreshCurrentTab(context, state.selectedTab),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshCurrentTab(BuildContext context, HistoryTab tab) async {
    switch (tab) {
      case HistoryTab.generation:
        return context.read<GenerationHistoryCubit>().load();
      case HistoryTab.docking:
        return context.read<DockingHistoryCubit>().load();
      case HistoryTab.md:
        return context.read<MdHistoryCubit>().load();
      case HistoryTab.drugRepurposing:
        return context.read<DrugRepurposingCubit>().load();
    }
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

class _ErrorSection extends StatelessWidget {
  final String message;
  const _ErrorSection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomFailureBody(
        icon: Icons.error_outline,
        msg: message,
        actionLabel: 'Try Again',
        onAction: () {},
      ),
    );
  }
}
