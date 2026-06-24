import 'package:ailixir/core/entities/drug_repurposing_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/features/history/presentation/cubits/drug_repurposing_cubit/drug_repurposing_cubit.dart';
import 'package:ailixir/features/history/presentation/views/drug_repurposing_job_detail_view.dart';
import 'package:ailixir/features/history/presentation/widgets/drug_repurposing_sub_tab_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DrugRepurposingSeeAllView extends StatefulWidget {
  static const routeName = '/history/drug-repurposing';
  const DrugRepurposingSeeAllView({super.key});

  @override
  State<DrugRepurposingSeeAllView> createState() => _DrugRepurposingSeeAllViewState();
}

class _DrugRepurposingSeeAllViewState extends State<DrugRepurposingSeeAllView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DrugRepurposingCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.slate1000,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Drug Repurposing History',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            Text(
              'All target and screening lookups',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ),
      body: BlocBuilder<DrugRepurposingCubit, DrugRepurposingState>(
        builder: (context, state) {
          final cubit = context.read<DrugRepurposingCubit>();

          if (state is DrugRepurposingLoading) {
            return Skeletonizer(
              enabled: true,
              child: _RepurposingList(
                items: DrugRepurposingEntity.createFakeData(),
                scrollController: _scrollController,
                isLoadingMore: false,
                hasMore: false,
              ),
            );
          }

          if (state is DrugRepurposingError) {
            return SizedBox.expand(
              child: Center(
                child: CustomEmptyBody(
                  icon: Icons.error_outline,
                  title: 'Error',
                  subTitle: state.message,
                  actionLabel: 'Retry',
                  onAction: () => cubit.loadAll(DrugRepurposingType.targets),
                ),
              ),
            );
          }

          if (state is DrugRepurposingLoaded) {
            final items = state.selectedSubTab == DrugRepurposingSubTab.targets
                ? state.targets
                : state.screen;

            if (items.isEmpty) {
              return SizedBox.expand(
                child: Center(
                  child: CustomEmptyBody(
                    icon: Icons.medication_outlined,
                    title: 'No History Found',
                    subTitle: 'No drug repurposing jobs yet.',
                    actionLabel: 'Refresh',
                    onAction: () => cubit.loadAll(DrugRepurposingType.targets),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
                  child: DrugRepurposingSubTabSelector(
                    selected: state.selectedSubTab,
                    onChanged: (tab) => cubit.selectSubTab(tab),
                  ),
                ),
                Expanded(
                  child: _RepurposingList(
                    items: items,
                    scrollController: _scrollController,
                    isLoadingMore: false,
                    hasMore: cubit.hasMore,
                  ),
                ),
              ],
            );
          }

          if (state is DrugRepurposingLoadingMore) {
            final items = state.selectedSubTab == DrugRepurposingSubTab.targets
                ? state.targets
                : state.screen;

            if (items.isEmpty) {
              return SizedBox.expand(
                child: Center(
                  child: CustomEmptyBody(
                    icon: Icons.medication_outlined,
                    title: 'No History Found',
                    subTitle: 'No drug repurposing jobs yet.',
                    actionLabel: 'Refresh',
                    onAction: () => cubit.loadAll(DrugRepurposingType.targets),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
                  child: DrugRepurposingSubTabSelector(
                    selected: state.selectedSubTab,
                    onChanged: (tab) => cubit.selectSubTab(tab),
                  ),
                ),
                Expanded(
                  child: _RepurposingList(
                    items: items,
                    scrollController: _scrollController,
                    isLoadingMore: true,
                    hasMore: cubit.hasMore,
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _RepurposingList extends StatelessWidget {
  final List<DrugRepurposingEntity> items;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const _RepurposingList({
    required this.items,
    required this.scrollController,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) {
          if (isLoadingMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.cyan400,
                  ),
                ),
              ),
            );
          }
          if (!hasMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  'No more results',
                  style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        return _RepurposingCard(entity: items[index]);
      },
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
              color: AppColors.amber400,
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
                color: AppColors.amber900.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Details',
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.amber400,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward_ios, size: 10.sp, color: AppColors.amber400),
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
