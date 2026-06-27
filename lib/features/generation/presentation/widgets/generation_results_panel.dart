import 'package:ailixir/core/entities/generation_files_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/generation/presentation/widgets/bulk_export_dialog.dart';
import 'package:ailixir/features/generation/presentation/widgets/ligand_export_dialog.dart';
import 'package:ailixir/features/history/presentation/views/ligand_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GenerationResultsPanel extends StatelessWidget {
  final List<LigandEntity> ligands;
  final GenerationFilesEntity? files;

  const GenerationResultsPanel({super.key, required this.ligands, this.files});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
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
                  'Generated SMILES',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white),
                ),
                SizedBox(width: 10.w),
                // All Compounds Valid badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.emerald900.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.emerald600.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.emerald400,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'All Compounds Valid',
                        style: AppTextStyles.labelsmall.copyWith(
                          color: AppColors.emerald400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (files != null)
              OutlinedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => BulkExportDialog(files: files!),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.emerald600),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                icon: Icon(
                  Icons.download_outlined,
                  color: AppColors.emerald400,
                  size: 14.sp,
                ),
                label: Text(
                  'Download All',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.emerald400,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 16.h),

        // Ligand cards
        ...ligands.map((l) => _GeneratedLigandCard(ligand: l)),

        SizedBox(height: 16.h),
      ],
    );
  }
}

class _GeneratedLigandCard extends StatelessWidget {
  final LigandEntity ligand;
  const _GeneratedLigandCard({required this.ligand});

  @override
  Widget build(BuildContext context) {
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
          // Avatar
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.slate700,
              borderRadius: BorderRadius.circular(6.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'SM',
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.slate300,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ligand.candidateName,
                  style: AppTextStyles.bodyxs.copyWith(
                    color: AppColors.slate400,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  ligand.smiles,
                  style: AppTextStyles.bodysmall.copyWith(
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Analyze
          OutlinedButton.icon(
            onPressed: () =>
                context.push(LigandDetailsView.routeName, extra: ligand),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.cyan600),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: AppColors.cyan400,
              size: 14.sp,
            ),
            label: Text(
              'Analyze',
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.cyan400,
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Download
          OutlinedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => LigandExportDialog(smiles: ligand.smiles),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.cyan600),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: Icon(
              Icons.download_outlined,
              color: AppColors.cyan400,
              size: 14.sp,
            ),
            label: Text(
              'Download',
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.cyan400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
