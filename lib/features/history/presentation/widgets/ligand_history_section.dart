import 'package:ailixir/core/entities/generation_job_history_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/features/generation/data/repos/generation_repo.dart';
import 'package:ailixir/features/history/presentation/cubits/generation_history_cubit/generation_history_cubit.dart';
import 'package:ailixir/features/history/presentation/views/ligand_details_view.dart';
import 'package:ailixir/features/history/presentation/views/ligand_see_all_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LigandHistorySection extends StatelessWidget {
  final List<GenerationJobHistoryEntity> jobs;
  const LigandHistorySection({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    final hasRunning = jobs.any((j) => j.isRunning);
    final hasFailed = jobs.any((j) => j.isFailed);
    final hasCompleted = jobs.any((j) => j.isCompleted);
    final hasCanceled = jobs.any((j) => j.isCancelled);

    return Column(
      mainAxisSize: jobs.isEmpty ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science_outlined,
                  color: AppColors.cyan400,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Ligand Generation History',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => GenerationHistoryCubit()..loadAll(),
                          child: const LigandSeeAllView(),
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
          ],
        ),
        SizedBox(height: 12.h),
        if (jobs.isEmpty)
          Expanded(
            child: Center(
              child: CustomEmptyBody(
                icon: Icons.science_outlined,
                title: 'No Ligands Yet',
                subTitle: 'Generated ligands will appear here.',
              ),
            ),
          )
        else ...[
          if (hasRunning) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                'Active',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.blue400,
                ),
              ),
            ),
            ...jobs.where((j) => j.isRunning).map((j) => _JobCard(job: j)),
            SizedBox(height: 12.h),
          ],
          if (hasFailed) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                'Failed',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.red400,
                ),
              ),
            ),
            ...jobs.where((j) => j.isFailed).map((j) => _JobCard(job: j)),
            SizedBox(height: 12.h),
          ],
          if (hasCanceled) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                'Cancelled',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.gray400,
                ),
              ),
            ),
            ...jobs.where((j) => j.isCancelled).map((j) => _JobCard(job: j)),
            SizedBox(height: 12.h),
          ],
          if (hasCompleted) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                'Completed',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.green400,
                ),
              ),
            ),
            ...jobs.where((j) => j.isCompleted).map((j) => _JobCard(job: j)),
          ],
        ],
      ],
    );
  }
}

class _JobCard extends StatefulWidget {
  final GenerationJobHistoryEntity job;
  const _JobCard({required this.job});

  @override
  State<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<_JobCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(job.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _buildHeader(context, job, dateStr),
          if (job.isCompleted && _expanded) ...[
            Divider(height: 1, color: AppColors.slate700),
            _buildLigandList(context, job),
          ],
        ],
      ),
    );
  }

  Color get _borderColor {
    if (widget.job.isRunning) return AppColors.blue700;
    if (widget.job.isFailed) return AppColors.red700;
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
          // Status icon
          _StatusIcon(job: job),
          SizedBox(width: 12.w),
          // Info
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
                    _StatusChip(job: job),
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
                    if ((job.isRunning || job.isCancelled || job.isFailed) &&
                        job.stage != null) ...[
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
                        '${job.ligands.length} / ${job.numMolecules} ligands',
                        style: AppTextStyles.bodyxs.copyWith(
                          color: AppColors.slate400,
                        ),
                      ),
                    ],
                  ],
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
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.slate400,
                size: 20.sp,
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

  Widget _buildLigandList(
    BuildContext context,
    GenerationJobHistoryEntity job,
  ) {
    if (job.ligands.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Text(
            'No ligands found for this job.',
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
          ),
        ),
      );
    }
    return Column(
      children: job.ligands.map((l) => _LigandRow(ligand: l)).toList(),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final GenerationJobHistoryEntity job;
  const _StatusIcon({required this.job});

  @override
  Widget build(BuildContext context) {
    if (job.isRunning) {
      return SizedBox(
        width: 20.w,
        height: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.blue400,
        ),
      );
    }
    if (job.isFailed) {
      return Icon(Icons.error, color: AppColors.red400, size: 20.sp);
    }
    if (job.isCancelled) {
      return Icon(Icons.cancel_outlined, color: AppColors.gray400, size: 20.sp);
    }
    return Icon(Icons.check_circle, color: AppColors.green400, size: 20.sp);
  }
}

class _StatusChip extends StatelessWidget {
  final GenerationJobHistoryEntity job;
  const _StatusChip({required this.job});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (job.status) {
      'running' => (AppColors.blue900, AppColors.blue300, 'Running'),
      'failed' => (AppColors.red900, AppColors.red300, 'Failed'),
      'cancelled' => (AppColors.gray900, AppColors.gray300, 'Cancelled'),
      _ => (AppColors.green900, AppColors.green300, 'Completed'),
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

class _LigandRow extends StatelessWidget {
  final LigandEntity ligand;
  const _LigandRow({required this.ligand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(LigandDetailsView.routeName, extra: ligand),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.slate700, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.slate700,
                borderRadius: BorderRadius.circular(6.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'SM',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.slate300,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ligand.candidateName,
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    ligand.smiles,
                    style: AppTextStyles.bodyxs.copyWith(
                      color: AppColors.slate400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right, color: AppColors.slate500, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
