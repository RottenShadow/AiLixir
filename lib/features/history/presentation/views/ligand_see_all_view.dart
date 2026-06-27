import 'package:ailixir/core/entities/generation_job_history_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/features/generation/data/repos/generation_repo.dart';
import 'package:ailixir/features/history/presentation/cubits/generation_history_cubit/generation_history_cubit.dart';
import 'package:ailixir/features/history/presentation/views/ligand_job_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LigandSeeAllView extends StatefulWidget {
  static const routeName = '/history/ligands';
  const LigandSeeAllView({super.key});

  @override
  State<LigandSeeAllView> createState() => _LigandSeeAllViewState();
}

class _LigandSeeAllViewState extends State<LigandSeeAllView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<GenerationHistoryCubit>().loadMore();
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
              'Ligand Generation History',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            Text(
              'All generation jobs',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ),
      body: BlocBuilder<GenerationHistoryCubit, GenerationHistoryState>(
        builder: (context, state) {
          final cubit = context.read<GenerationHistoryCubit>();

          if (state is GenerationHistoryLoading) {
            return Skeletonizer(
              enabled: true,
              child: _JobList(
                items: _fakeSkeletonJobs,
                scrollController: _scrollController,
                isLoadingMore: false,
                hasMore: false,
              ),
            );
          }

          if (state is GenerationHistoryError) {
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

          final items = state is GenerationHistoryLoaded
              ? state.jobs
              : (state as GenerationHistoryLoadingMore).jobs;

          if (items.isEmpty) {
            return SizedBox.expand(
              child: Center(
                child: CustomEmptyBody(
                  icon: Icons.science_outlined,
                  title: 'No Jobs Found',
                  subTitle:
                      'No generation jobs yet.\nStart a generation job to see results here.',
                  actionLabel: 'Refresh',
                  onAction: () => cubit.loadAll(),
                ),
              ),
            );
          }

          return _JobList(
            items: items,
            scrollController: _scrollController,
            isLoadingMore: state is GenerationHistoryLoadingMore,
            hasMore: cubit.hasMore,
          );
        },
      ),
    );
  }
}

class _JobList extends StatelessWidget {
  final List<GenerationJobHistoryEntity> items;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const _JobList({
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

        return _JobSeeAllCard(job: items[index]);
      },
    );
  }
}

class _JobSeeAllCard extends StatelessWidget {
  final GenerationJobHistoryEntity job;
  const _JobSeeAllCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(job.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _borderColor),
      ),
      child: _buildHeader(context, job, dateStr),
    );
  }

  Color get _borderColor {
    if (job.isRunning) return AppColors.blue700;
    if (job.isFailed) return AppColors.red700;
    return AppColors.brandBorder;
  }

  Widget _buildHeader(
    BuildContext context,
    GenerationJobHistoryEntity job,
    String dateStr,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          if (job.isRunning)
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.blue400,
              ),
            )
          else if (job.isFailed)
            Icon(Icons.error, color: AppColors.red400, size: 20.sp)
          else if (job.isCancelled)
            Icon(Icons.cancel_outlined, color: AppColors.gray400, size: 20.sp)
          else
            Icon(Icons.check_circle, color: AppColors.green400, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        job.jobId,
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _StatusChip(status: job.status),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      dateStr,
                      style: AppTextStyles.bodyxs.copyWith(
                        color: AppColors.slate400,
                      ),
                    ),
                    if (job.isRunning && job.stage != null) ...[
                      SizedBox(width: 12.w),
                      Text(
                        'Stage: ${job.stage}',
                        style: AppTextStyles.bodyxs.copyWith(
                          color: AppColors.blue300,
                        ),
                      ),
                    ],
                    if (!job.isRunning) ...[
                      SizedBox(width: 12.w),
                      Text(
                        '${job.ligands.length} ligands',
                        style: AppTextStyles.bodyxs.copyWith(
                          color: AppColors.slate400,
                        ),
                      ),
                    ],
                  ],
                ),
                if (job.isFailed && job.summary != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      job.summary!,
                      style: AppTextStyles.bodyxs.copyWith(
                        color: AppColors.red300,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          if (job.isRunning)
            GestureDetector(
              onTap: () => _cancelJob(context, job),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.red900.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.red700),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.red300,
                  ),
                ),
              ),
            ),
          if (job.isCompleted)
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LigandJobDetailsView(job: job),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.cyan600),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                color: AppColors.cyan400,
                size: 12.sp,
              ),
              label: Text(
                'See Details',
                style: AppTextStyles.caption.copyWith(color: AppColors.cyan400),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _cancelJob(
    BuildContext context,
    GenerationJobHistoryEntity job,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.slate800,
        title: Text(
          'Cancel Job',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Are you sure you want to cancel this generation job?',
          style: AppTextStyles.bodysmall.copyWith(color: AppColors.slate300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'No',
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.slate400,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Yes, Cancel',
              style: AppTextStyles.labelsmall.copyWith(color: AppColors.red400),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final repo = GetIt.I.get<GenerationRepo>();
    final result = await repo.cancelJob(job.jobId);
    result.fold(
      (failure) {
        if (context.mounted) {
          AppToast.showErrorToast(
            context: context,
            message: 'Failed to cancel job: ${failure.message}',
          );
        }
      },
      (_) {
        if (context.mounted) {
          AppToast.showSuccessToast(
            context: context,
            message: 'Job cancelled successfully',
          );
          context.read<GenerationHistoryCubit>().load();
        }
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status) {
      'running' => (AppColors.blue900, AppColors.blue400, 'Running'),
      'failed' => (AppColors.red900, AppColors.red400, 'Failed'),
      'cancelled' => (AppColors.gray900, AppColors.gray400, 'Cancelled'),
      _ => (AppColors.green900, AppColors.green400, 'Completed'),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: fg)),
    );
  }
}

final List<GenerationJobHistoryEntity> _fakeSkeletonJobs = List.generate(
  10,
  (i) => GenerationJobHistoryEntity(
    id: '$i',
    jobId: 'skel_$i',
    status: 'completed',
    preset: 'generator_preset',
    numMolecules: 100,
    returnTopK: 10,
    dockingMode: 'off',
    dockTopK: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    ligands: [],
  ),
);
