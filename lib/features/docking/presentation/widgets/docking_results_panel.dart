import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/docking_score_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/file_download_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DockingResultsPanel extends StatelessWidget {
  final List<DockingEntity> results;
  const DockingResultsPanel({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.hub_outlined, color: AppColors.cyan400, size: 16.sp),
            SizedBox(width: 6.w),
            Text(
              'Docking Results',
              style: AppTextStyles.h5.copyWith(color: AppColors.white),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ...results.map((r) => _DockingResultCard(result: r)),
      ],
    );
  }
}

class _DockingResultCard extends StatelessWidget {
  final DockingEntity result;
  const _DockingResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final sorted = List<DockingScoreEntity>.from(result.scores)
      ..sort((a, b) => a.affinity.compareTo(b.affinity));

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Target: ${result.targetId} (${result.targetName})',
                  style: AppTextStyles.h6.copyWith(color: AppColors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: result.downloadUrl != null
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              FileDownloadView(url: result.downloadUrl!),
                        ),
                      )
                    : null,
                child: Icon(
                  Icons.download_outlined,
                  color: result.downloadUrl != null
                      ? AppColors.cyan400
                      : AppColors.slate600,
                  size: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Job: ${result.jobId}',
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
          ),
          SizedBox(height: 8.h),
          // Scores table header
          Row(
            children: [
              _ScoreHeader(label: '#', flex: 1),
              _ScoreHeader(label: 'Affinity', flex: 3),
              _ScoreHeader(label: 'Inter', flex: 3),
              _ScoreHeader(label: 'Intra', flex: 3),
              _ScoreHeader(label: 'Torsions', flex: 3),
              _ScoreHeader(label: 'Unbound', flex: 3),
            ],
          ),
          SizedBox(height: 4.h),
          ...sorted.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            final isBest = i == 0;
            return _ScoreRow(index: i, score: s, isBest: isBest);
          }),
          SizedBox(height: 4.h),
          _BestScoreBanner(vinaScore: result.vinaScore),
        ],
      ),
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  final String label;
  final int flex;
  const _ScoreHeader({required this.label, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: AppTextStyles.bodyxs.copyWith(
          color: AppColors.slate500,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final int index;
  final DockingScoreEntity score;
  final bool isBest;
  const _ScoreRow({
    required this.index,
    required this.score,
    required this.isBest,
  });

  @override
  Widget build(BuildContext context) {
    final color = isBest ? AppColors.emerald400 : AppColors.slate300;
    final bg = isBest ? AppColors.emerald900.withValues(alpha: 0.15) : null;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
      decoration: bg != null
          ? BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4.r))
          : null,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '#${index + 1}',
              style: AppTextStyles.bodyxs.copyWith(color: color),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              score.affinity.toStringAsFixed(3),
              style: AppTextStyles.bodyxs.copyWith(
                color: color,
                fontWeight: isBest ? FontWeight.w700 : null,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              score.inter.toStringAsFixed(3),
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              score.intra.toStringAsFixed(3),
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              score.torsions.toStringAsFixed(3),
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              score.unbound.toStringAsFixed(3),
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ),
        ],
      ),
    );
  }
}

class _BestScoreBanner extends StatelessWidget {
  final double vinaScore;
  const _BestScoreBanner({required this.vinaScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.emerald900.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, size: 12.sp, color: AppColors.emerald400),
          SizedBox(width: 4.w),
          Text(
            'Best affinity: ${vinaScore.toStringAsFixed(3)} kcal/mol',
            style: AppTextStyles.bodyxs.copyWith(
              color: AppColors.emerald400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
