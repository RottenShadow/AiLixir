import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/core/widgets/file_download_view.dart';
import 'package:ailixir/features/history/presentation/cubits/md_history_cubit/md_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MdSeeAllView extends StatefulWidget {
  static const routeName = '/history/md';
  const MdSeeAllView({super.key});

  @override
  State<MdSeeAllView> createState() => _MdSeeAllViewState();
}

class _MdSeeAllViewState extends State<MdSeeAllView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MdHistoryCubit>().loadMore();
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
              'Molecular Dynamics History',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            Text(
              'All MD simulations',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ),
      body: BlocBuilder<MdHistoryCubit, MdHistoryState>(
        builder: (context, state) {
          final cubit = context.read<MdHistoryCubit>();

          if (state is MdHistoryLoading) {
            return Skeletonizer(
              enabled: true,
              child: _MdTable(
                items: MdEntity.createFakeData(),
                scrollController: _scrollController,
                isLoadingMore: false,
                hasMore: false,
              ),
            );
          }

          if (state is MdHistoryError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                child: Text(
                  state.message,
                  style: AppTextStyles.bodymedium.copyWith(
                    color: AppColors.red400,
                  ),
                ),
              ),
            );
          }

          final items = state is MdHistoryLoaded
              ? state.mdSimulations
              : (state as MdHistoryLoadingMore).mdSimulations;

          if (items.isEmpty) {
            return SizedBox.expand(
              child: Center(
                child: CustomEmptyBody(
                  icon: Icons.blur_on,
                  title: 'No MD Simulations Found',
                  subTitle:
                      'No MD simulations yet.\nSubmit a simulation to see results here.',
                ),
              ),
            );
          }

          return _MdTable(
            items: items,
            scrollController: _scrollController,
            isLoadingMore: state is MdHistoryLoadingMore,
            hasMore: cubit.hasMore,
          );
        },
      ),
    );
  }
}

// ── Table ────────────────────────────────────────────────────────────────────

class _MdTable extends StatelessWidget {
  final List<MdEntity> items;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const _MdTable({
    required this.items,
    required this.scrollController,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          color: AppColors.slate900,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Simulation Task',
                  style: AppTextStyles.labelsmall
                      .copyWith(color: AppColors.slate500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Forcefield',
                  style: AppTextStyles.labelsmall
                      .copyWith(color: AppColors.slate500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Duration',
                  style: AppTextStyles.labelsmall
                      .copyWith(color: AppColors.slate500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Status',
                  style: AppTextStyles.labelsmall
                      .copyWith(color: AppColors.slate500),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Downloads',
                  style: AppTextStyles.labelsmall
                      .copyWith(color: AppColors.slate500),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.brandBorder, height: 1),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 24.h),
            itemCount: items.length + 1,
            separatorBuilder: (_, __) =>
                Divider(color: AppColors.brandBorder, height: 1),
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
                          color: AppColors.purple400,
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
                        style: AppTextStyles.bodyxs
                            .copyWith(color: AppColors.slate500),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
              return _MdRow(md: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

// ── Row ───────────────────────────────────────────────────────────────────────

class _MdRow extends StatelessWidget {
  final MdEntity md;
  const _MdRow({required this.md});

  String _resolveUrl(String? fromMeta, String fallbackPath) {
    final raw =
        (fromMeta != null && fromMeta.isNotEmpty) ? fromMeta : fallbackPath;
    if (raw.startsWith('http')) return raw;
    // Strip trailing /api/ from base and prepend
    final base = AppEndpoints.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    return '$base$raw';
  }

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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  md.simulationTask,
                  style: AppTextStyles.bodysmall
                      .copyWith(color: AppColors.white),
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
                _DownloadBtn(
                  label: 'Results',
                  icon: Icons.download_rounded,
                  url: resultsUrl,
                  title: 'MD Results — ${md.simulationTask}',
                  enabled: hasResults,
                  color: AppColors.violet400,
                ),
                SizedBox(width: 8.w),
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
}

// ── Download button ───────────────────────────────────────────────────────────

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

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final MdStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      MdStatus.completed => (
        AppColors.emerald900.withValues(alpha: 0.5),
        AppColors.emerald400,
        'COMPLETED',
      ),
      MdStatus.running => (
        AppColors.blue900.withValues(alpha: 0.5),
        AppColors.blue400,
        'RUNNING',
      ),
      MdStatus.failed => (
        AppColors.red900.withValues(alpha: 0.5),
        AppColors.red400,
        'FAILED',
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelsmall.copyWith(color: fg),
      ),
    );
  }
}
