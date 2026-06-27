import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/core/widgets/file_download_view.dart';
import 'package:ailixir/features/history/presentation/cubits/docking_history_cubit/docking_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DockingSeeAllView extends StatefulWidget {
  static const routeName = '/history/docking';
  const DockingSeeAllView({super.key});

  @override
  State<DockingSeeAllView> createState() => _DockingSeeAllViewState();
}

class _DockingSeeAllViewState extends State<DockingSeeAllView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DockingHistoryCubit>().loadMore();
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
              'Docking History',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            Text(
              'All docking simulations',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ),
      body: BlocBuilder<DockingHistoryCubit, DockingHistoryState>(
        builder: (context, state) {
          final cubit = context.read<DockingHistoryCubit>();

          if (state is DockingHistoryLoading) {
            return Skeletonizer(
              enabled: true,
              child: _DockingList(
                items: DockingEntity.createFakeData(),
                scrollController: _scrollController,
                isLoadingMore: false,
                hasMore: false,
              ),
            );
          }

          if (state is DockingHistoryError) {
            return SizedBox.expand(
              child: Center(
                child: CustomEmptyBody(
                  icon: Icons.error_outline,
                  title: 'Error',
                  subTitle: state.message,
                  actionLabel: 'Retry',
                  onAction: () => cubit.loadAll(),
                ),
              ),
            );
          }

          final items = state is DockingHistoryLoaded
              ? state.dockings
              : (state as DockingHistoryLoadingMore).dockings;

          if (items.isEmpty) {
            return SizedBox.expand(
              child: Center(
                child: CustomEmptyBody(
                  icon: Icons.hub_outlined,
                  title: 'No Docking Results',
                  subTitle:
                      'No docking simulations yet.\nSubmit a docking job to see results here.',
                  actionLabel: 'Refresh',
                  onAction: () => cubit.loadAll(),
                ),
              ),
            );
          }

          return _DockingList(
            items: items,
            scrollController: _scrollController,
            isLoadingMore: state is DockingHistoryLoadingMore,
            hasMore: cubit.hasMore,
          );
        },
      ),
    );
  }
}

class _DockingList extends StatelessWidget {
  final List<DockingEntity> items;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const _DockingList({
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
                  style: AppTextStyles.bodyxs.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        return _DockingRow(docking: items[index]);
      },
    );
  }
}

class _DockingRow extends StatelessWidget {
  final DockingEntity docking;
  const _DockingRow({required this.docking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Row(
        children: [
          // Target badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.slate700,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              docking.targetId,
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.cyan300,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docking.targetName,
                  style: AppTextStyles.h6.copyWith(color: AppColors.white),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Job ID: ${docking.jobId}',
                  style: AppTextStyles.bodyxs.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${docking.vinaScore.toStringAsFixed(3)} kcal/mol',
                style: AppTextStyles.h5.copyWith(color: AppColors.cyan400),
              ),
              Text(
                '${docking.scores.length} poses',
                style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
              ),
            ],
          ),
          SizedBox(width: 12.w),
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
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: docking.downloadUrl != null
                    ? AppColors.slate700
                    : AppColors.slate800,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.download_outlined,
                color: docking.downloadUrl != null
                    ? AppColors.slate300
                    : AppColors.slate600,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
