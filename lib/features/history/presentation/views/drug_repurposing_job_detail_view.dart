import 'package:ailixir/core/entities/drug_repurposing_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrugRepurposingJobDetailView extends StatelessWidget {
  final DrugRepurposingEntity job;

  const DrugRepurposingJobDetailView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final isTargets = job.type == DrugRepurposingType.targets;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.slate1000,
        surfaceTintColor: AppColors.slate1000,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job #${job.id}',
              style: AppTextStyles.caption.copyWith(color: AppColors.slate400),
            ),
            Text(
              job.diseaseName,
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
      body: isTargets ? _TargetsView(job: job) : _ScreenView(job: job),
    );
  }
}

// ── Targets View ─────────────────────────────────────────────────────────────

class _TargetsView extends StatelessWidget {
  final DrugRepurposingEntity job;
  const _TargetsView({required this.job});

  @override
  Widget build(BuildContext context) {
    final targets = job.targets ?? [];
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      children: [
        DrSectionTitle(
          icon: Icons.radar,
          title: 'Protein Targets',
          subtitle:
              '${job.totalTargets ?? targets.length} targets found for "${job.diseaseName}"',
          accentColor: const Color(0xFF22D3EE),
        ),
        SizedBox(height: 14.h),
        if (targets.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Text(
                'No target data available.',
                style: AppTextStyles.bodymedium.copyWith(
                  color: AppColors.slate400,
                ),
              ),
            ),
          )
        else
          ...List.generate(
            targets.length,
            (i) => _TargetCard(target: targets[i], index: i),
          ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

// ── Screen View ──────────────────────────────────────────────────────────────

class _ScreenView extends StatelessWidget {
  final DrugRepurposingEntity job;
  const _ScreenView({required this.job});

  @override
  Widget build(BuildContext context) {
    final candidates = job.topCandidates ?? [];
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Targets Found',
                value: '${job.totalTargets ?? job.resultCount}',
                icon: Icons.radar,
                color: const Color(0xFF22D3EE),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _StatCard(
                label: 'Drugs Screened',
                value: '${job.totalDrugsScreened ?? 0}',
                icon: Icons.medication,
                color: const Color(0xFF8B5CF6),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _StatCard(
                label: 'Pairs Evaluated',
                value: '${job.totalPairsEvaluated ?? 0}',
                icon: Icons.compare_arrows,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        DrSectionTitle(
          icon: Icons.emoji_events,
          title: 'Top Candidates',
          subtitle:
              '${candidates.length} drug-target pairs ranked by binding score',
          accentColor: const Color(0xFF8B5CF6),
        ),
        SizedBox(height: 14.h),
        if (candidates.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Text(
                'No candidate data available.',
                style: AppTextStyles.bodymedium.copyWith(
                  color: AppColors.slate400,
                ),
              ),
            ),
          )
        else
          ...List.generate(
            candidates.length,
            (i) =>
                _CandidateCard(candidate: candidates[i], isTopRanked: i == 0),
          ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: color),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.h4.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.authTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Target Card (matches DrTargetCard) ───────────────────────────────────────

class _TargetCard extends StatelessWidget {
  final DrugRepurposingHistoryTarget target;
  final int index;
  const _TargetCard({required this.target, required this.index});

  @override
  Widget build(BuildContext context) {
    final scoreColor = target.score >= 0.7
        ? const Color(0xFF10B981)
        : target.score >= 0.4
        ? const Color(0xFFF59E0B)
        : AppColors.slate400;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brandBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1E69FF).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFF1E69FF).withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF60A5FA),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: const Color(0xFF8B5CF6).withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        target.symbol,
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFFA78BFA),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        target.name,
                        style: AppTextStyles.bodysmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    if (target.uniprotId.isNotEmpty)
                      _DetailChip(
                        icon: Icons.link,
                        label: 'UniProt: ${target.uniprotId}',
                        color: const Color(0xFF22D3EE),
                      ),
                    if (target.pdbIds.isNotEmpty)
                      ...target.pdbIds
                          .take(3)
                          .map(
                            (e) => _DetailChip(
                              icon: Icons.view_in_ar,
                              label: 'PDB: $e',
                              color: const Color(0xFF10B981),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Score',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.slate500,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: scoreColor.withOpacity(0.4)),
                ),
                child: Text(
                  target.score.toStringAsFixed(3),
                  style: AppTextStyles.labelmedium.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Candidate Card (matches DrCandidateCard) ──────────────────────────────────

class _CandidateCard extends StatelessWidget {
  final DrugRepurposingHistoryCandidate candidate;
  final bool isTopRanked;
  const _CandidateCard({required this.candidate, this.isTopRanked = false});

  @override
  Widget build(BuildContext context) {
    final score = candidate.bindingScore;
    final scoreColor = score >= 0.7
        ? const Color(0xFF10B981)
        : score >= 0.4
        ? const Color(0xFFF59E0B)
        : AppColors.slate400;
    final statusColor = _statusColor(candidate.status);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isTopRanked
              ? const Color(0xFFF59E0B).withOpacity(0.5)
              : AppColors.brandBorder,
          width: isTopRanked ? 1.5 : 1,
        ),
        boxShadow: [
          if (isTopRanked)
            BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    gradient: isTopRanked
                        ? const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                          )
                        : null,
                    color: isTopRanked
                        ? null
                        : const Color(0xFF1E69FF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                    border: isTopRanked
                        ? null
                        : Border.all(
                            color: const Color(0xFF1E69FF).withOpacity(0.3),
                          ),
                  ),
                  child: Center(
                    child: Text(
                      '#${candidate.rank}',
                      style: AppTextStyles.caption.copyWith(
                        color: isTopRanked
                            ? Colors.black
                            : const Color(0xFF60A5FA),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            candidate.drugName,
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isTopRanked) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF59E0B,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: const Color(
                                    0xFFF59E0B,
                                  ).withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 9.sp,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'TOP',
                                    style: AppTextStyles.caption.copyWith(
                                      color: const Color(0xFFF59E0B),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Target: ${candidate.targetSymbol}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.authTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: scoreColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        candidate.bindingScore.toStringAsFixed(3),
                        style: AppTextStyles.labelmedium.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: statusColor.withOpacity(0.35),
                        ),
                      ),
                      child: Text(
                        candidate.status.isEmpty ? 'Unknown' : candidate.status,
                        style: AppTextStyles.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (candidate.uniprotId.isNotEmpty ||
              candidate.smiles.isNotEmpty) ...[
            Divider(color: AppColors.brandBorder, height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children: [
                  if (candidate.uniprotId.isNotEmpty)
                    _DetailChip(
                      icon: Icons.link,
                      label: 'UniProt: ${candidate.uniprotId}',
                      color: const Color(0xFF22D3EE),
                    ),
                  if (candidate.smiles.isNotEmpty)
                    _DetailChip(
                      icon: Icons.science,
                      label: 'SMILES: ${candidate.smiles}',
                      color: const Color(0xFF8B5CF6),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF10B981);
      case 'investigational':
        return const Color(0xFF22D3EE);
      case 'experimental':
        return const Color(0xFFF59E0B);
      default:
        return AppColors.slate400;
    }
  }
}

// ── Detail Chip ──────────────────────────────────────────────────────────────

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _DetailChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
