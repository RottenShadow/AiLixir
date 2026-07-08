import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_screen_response_entity.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_top_candidate_entity.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/full/dr_full_cubit.dart';
import 'package:ailixir/features/drug_repurposing/domain/enum/dr_mode.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_error_banner.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Results panel for Full Screening Mode — stats + candidate cards.
class DrFullResults extends StatelessWidget {
  const DrFullResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrFullCubit, DrFullState>(
      builder: (context, state) {
        return switch (state) {
          DrFullSuccess(:final response) => SelectionArea(
            child: _CandidatesList(response: response),
          ),
          DrFullError(:final message) => DrErrorBanner(
            message: message,
            mode: DrugRepurposingMode.full,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

// ── Candidates list ───────────────────────────────────────────────────────────

class _CandidatesList extends StatelessWidget {
  final DrugRepurposingScreenResponseEntity response;
  const _CandidatesList({required this.response});

  void _copyToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('Drug Repurposing Results - Full Screening Mode');
    buffer.writeln('----------------------------------------------');
    buffer.writeln('Targets Found: ${response.totalTargetsFound}');
    buffer.writeln('Drugs Screened: ${response.totalDrugsScreened}');
    buffer.writeln('Pairs Evaluated: ${response.totalPairsEvaluated}');
    buffer.writeln('');
    buffer.writeln('Rank | Drug | Target | Score | Status | UniProt | SMILES');
    buffer.writeln('--------------------------------------------------------');

    for (var i = 0; i < response.topCandidates.length; i++) {
      final c = response.topCandidates[i];
      buffer.writeln(
        '${c.rank} | ${c.drugName} | ${c.targetSymbol} | ${c.bindingScore.toStringAsFixed(3)} | ${c.status.isEmpty ? 'Unknown' : c.status} | ${c.uniprotId.isEmpty ? 'N/A' : c.uniprotId} | ${c.smiles.isEmpty ? 'N/A' : c.smiles}',
      );
    }

    Clipboard.setData(ClipboardData(text: buffer.toString())).then((_) {
      if (context.mounted) {
        AppToast.showSuccessToast(
          context: context,
          message: 'Results copied to clipboard',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        _StatsRow(response: response),
        SizedBox(height: 20.h),
        DrSectionTitle(
          icon: Icons.emoji_events,
          title: 'Top Candidates',
          subtitle:
              '${response.topCandidates.length} drug-target pairs ranked by binding score',
          accentColor: AppColors.cyan400,
          trailing: IconButton(
            onPressed: () => _copyToClipboard(context),
            icon: Icon(
              Icons.copy_rounded,
              size: 18.sp,
              color: AppColors.slate400,
            ),
            tooltip: 'Copy results',
          ),
        ),
        SizedBox(height: 14.h),
        ...List.generate(
          response.topCandidates.length,
          (i) => DrCandidateCard(
            candidate: response.topCandidates[i],
            isTopRanked: i == 0,
          ),
        ),
      ],
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final DrugRepurposingScreenResponseEntity response;
  const _StatsRow({required this.response});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Targets Found',
            value: '${response.totalTargetsFound}',
            icon: Icons.radar,
            color: AppColors.cyan400,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCard(
            label: 'Drugs Screened',
            value: '${response.totalDrugsScreened}',
            icon: Icons.medication,
            color: AppColors.cyan400,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCard(
            label: 'Pairs Evaluated',
            value: '${response.totalPairsEvaluated}',
            icon: Icons.compare_arrows,
            color: AppColors.cyan400,
          ),
        ),
      ],
    );
  }
}

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

// ── Candidate card ────────────────────────────────────────────────────────────

class DrCandidateCard extends StatelessWidget {
  final DrugRepurposingTopCandidateEntity candidate;
  final bool isTopRanked;

  const DrCandidateCard({
    super.key,
    required this.candidate,
    this.isTopRanked = false,
  });

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
          _CardHeader(
            candidate: candidate,
            isTopRanked: isTopRanked,
            scoreColor: scoreColor,
            statusColor: statusColor,
          ),
          Divider(color: AppColors.brandBorder, height: 1),
          _CardBody(candidate: candidate),
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

class _CardHeader extends StatelessWidget {
  final DrugRepurposingTopCandidateEntity candidate;
  final bool isTopRanked;
  final Color scoreColor;
  final Color statusColor;

  const _CardHeader({
    required this.candidate,
    required this.isTopRanked,
    required this.scoreColor,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.r),
      child: Row(
        children: [
          // Rank badge
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
                  : Border.all(color: const Color(0xFF1E69FF).withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                '#${candidate.rank}',
                style: AppTextStyles.caption.copyWith(
                  color: isTopRanked ? Colors.black : const Color(0xFF60A5FA),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Drug name + target
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
                          color: const Color(0xFFF59E0B).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFFF59E0B).withOpacity(0.5),
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

          // Score + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: statusColor.withOpacity(0.35)),
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
    );
  }
}

class _CardBody extends StatelessWidget {
  final DrugRepurposingTopCandidateEntity candidate;
  const _CardBody({required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 6.h,
        children: [
          if (candidate.uniprotId.isNotEmpty)
            _DetailChip(
              icon: Icons.link,
              label: 'UniProt: ${candidate.uniprotId}',
            color: AppColors.cyan400,
            ),
          if (candidate.smiles.isNotEmpty)
            _DetailChip(
              icon: Icons.science,
              label: 'SMILES: ${candidate.smiles}',
              color: AppColors.cyan400,
            ),
        ],
      ),
    );
  }
}

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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: color.withOpacity(0.7)),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
