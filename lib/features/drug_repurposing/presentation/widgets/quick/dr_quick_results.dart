import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_target_entity.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_targets_response_entity.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/quick/dr_quick_cubit.dart';
import 'package:ailixir/features/drug_repurposing/domain/enum/dr_mode.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_error_banner.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Results panel for Quick Mode — shows protein target cards.
class DrQuickResults extends StatelessWidget {
  const DrQuickResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrQuickCubit, DrQuickState>(
      builder: (context, state) {
        if (state is DrQuickSuccess) {
          return SelectionArea(child: _TargetsList(response: state.response));
        } else if (state is DrQuickError) {
          return DrErrorBanner(
            message: state.message,
            mode: DrugRepurposingMode.quick,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ── Targets list ──────────────────────────────────────────────────────────────

class _TargetsList extends StatelessWidget {
  final DrugRepurposingTargetsResponseEntity response;
  const _TargetsList({required this.response});

  void _copyToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('Drug Repurposing Results - Quick Mode');
    buffer.writeln('---------------------------------------');
    buffer.writeln('Disease: ${response.diseaseName}');
    buffer.writeln('Total Targets: ${response.totalTargets}');
    buffer.writeln('');
    buffer.writeln('Rank | Symbol | Name | UniProt | Score | List of PDBs');
    buffer.writeln('-------------------------------------------------------');

    for (var i = 0; i < response.targets.length; i++) {
      final t = response.targets[i];
      buffer.writeln(
        '${i + 1} | ${t.symbol} | ${t.name} | ${t.uniprotId.isEmpty ? 'N/A' : t.uniprotId} | ${t.associationScore.toStringAsFixed(3)} | ${t.pdbIds.isEmpty ? 'N/A' : t.pdbIds.join(', ')}',
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
        DrSectionTitle(
          icon: Icons.radar,
          title: 'Protein Targets',
          subtitle:
              '${response.totalTargets} targets found for "${response.diseaseName}"',
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
          response.targets.length,
          (i) => DrTargetCard(target: response.targets[i], index: i),
        ),
      ],
    );
  }
}

// ── Target card ───────────────────────────────────────────────────────────────

class DrTargetCard extends StatelessWidget {
  final DrugRepurposingTargetEntity target;
  final int index;

  const DrTargetCard({super.key, required this.target, required this.index});

  @override
  Widget build(BuildContext context) {
    final score = target.associationScore;
    final scoreColor = score >= 0.7
        ? const Color(0xFF10B981)
        : score >= 0.4
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
          // Rank badge
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

          // Main info
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
                        color: AppColors.cyan400.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColors.cyan400.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        target.symbol,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.cyan400,
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
                    _InfoChip(
                      icon: Icons.link,
                      label: target.uniprotId.isEmpty
                          ? 'UniProt: N/A'
                          : 'UniProt: ${target.uniprotId}',
                      color: AppColors.cyan400,
                    ),
                    if (target.pdbIds.isNotEmpty)
                      ...target.pdbIds
                          .take(3)
                          .map(
                            (e) => _InfoChip(
                              icon: Icons.view_in_ar,
                              label: 'PDB: $e',
                              color: AppColors.cyan400,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Score badge
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
                  score.toStringAsFixed(3),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
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
