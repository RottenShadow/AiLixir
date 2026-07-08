import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/core/widgets/file_download_view.dart';
import 'package:ailixir/features/history/presentation/cubits/md_history_cubit/md_history_cubit.dart';
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
      mainAxisSize: mdSimulations.isEmpty ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.blur_on, color: AppColors.cyan400, size: 20.sp),
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
                      create: (_) => MdHistoryCubit()..loadAll(),
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
        if (mdSimulations.isEmpty)
          Expanded(
            child: Center(
              child: CustomEmptyBody(
                icon: Icons.blur_on,
                title: 'No MD Simulations Yet',
                subTitle: 'Molecular dynamics results will appear here.',
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.slate800,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.brandBorder),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
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
                          'Downloads',
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
    final isCompleted = md.status == MdStatus.completed;
    final resultsUrl = _resolveUrl(
      md.resultMeta?.downloadUrl,
      AppEndpoints.mdSimulationDownload(md.id),
    );
    final analysisUrl = _resolveUrl(
      md.analysisMeta?.downloadUrl ?? md.resultMeta?.downloadAnalysisUrl,
      AppEndpoints.mdSimulationDownloadAnalysis(md.id),
    );
    final hasResults = isCompleted && md.resultMeta?.downloadUrl != null;
    final hasAnalysis = isCompleted &&
        (md.analysisMeta?.downloadUrl != null ||
            md.resultMeta?.downloadAnalysisUrl != null);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          // Task name + date
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
                  overflow: TextOverflow.ellipsis,
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
          // Forcefield
          Expanded(
            flex: 2,
            child: Text(
              md.forcefield,
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.slate300,
              ),
            ),
          ),
          // Duration
          Expanded(
            flex: 2,
            child: Text(
              md.duration,
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.slate300,
              ),
            ),
          ),
          // Status badge
          Expanded(flex: 2, child: _StatusBadge(status: md.status)),
          // Download buttons
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _DownloadBtn(
                  label: 'Results',
                  icon: Icons.download_rounded,
                  url: resultsUrl,
                  title: 'MD Results — ${md.simulationTask}',
                  enabled: hasResults,
                  color: AppColors.cyan400,
                ),
                SizedBox(width: 6.w),
                _DownloadBtn(
                  label: 'Analysis',
                  icon: Icons.analytics_outlined,
                  url: analysisUrl,
                  title: 'MD Analysis — ${md.simulationTask}',
                  enabled: hasAnalysis,
                  color: AppColors.cyan400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Resolves a relative path against the base URL, or falls back to the
  /// generated endpoint path (also relative — callers append base if needed).
  String _resolveUrl(String? fromMeta, String fallbackPath) {
    final raw = fromMeta?.isNotEmpty == true ? fromMeta! : fallbackPath;
    if (raw.startsWith('http')) return raw;
    final base = AppEndpoints.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    return '$base$raw';
  }
}

// ── Download button ─────────────────────────────────────────────────────────

class _DownloadBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;
  final String title;
  final bool enabled;
  final Color color;

  const _DownloadBtn({
    required this.label,
    required this.icon,
    required this.url,
    required this.title,
    required this.enabled,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FileDownloadView(url: url, title: title),
                ),
              )
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.12)
              : AppColors.slate700.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: enabled
                ? color.withValues(alpha: 0.4)
                : AppColors.brandBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: enabled ? color : AppColors.slate500,
              size: 12.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: enabled ? color : AppColors.slate500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final MdStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;

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
      child: Text(
        label,
        style: AppTextStyles.labelsmall.copyWith(color: text),
      ),
    );
  }
}
