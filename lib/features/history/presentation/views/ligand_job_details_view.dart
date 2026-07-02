import 'package:ailixir/core/entities/generation_job_history_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/generation/presentation/widgets/generation_results_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LigandJobDetailsView extends StatelessWidget {
  final GenerationJobHistoryEntity job;
  static const routeName = '/history/ligand-job-details';

  const LigandJobDetailsView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(job.createdAt);
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
              job.jobId,
              style: AppTextStyles.h6.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 2.h),
            Text(
              dateStr,
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: GenerationResultsPanel(
          ligands: job.ligands,
          files: job.files,
        ),
      ),
    );
  }
}
