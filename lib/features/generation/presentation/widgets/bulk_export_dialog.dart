import 'package:ailixir/core/entities/generation_files_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/file_download_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BulkExportDialog extends StatelessWidget {
  final GenerationFilesEntity files;

  const BulkExportDialog({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    final items = <(String, GenerationFileItemEntity)>[];
    if (files.csv != null) items.add(('CSV', files.csv!));
    if (files.json != null) items.add(('JSON', files.json!));

    return AlertDialog(
      backgroundColor: AppColors.slate800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      content: Padding(
        padding: EdgeInsets.all(20.w),
        child: SizedBox(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export All Results',
                style: AppTextStyles.h4.copyWith(color: AppColors.white),
              ),
              SizedBox(height: 4.h),
              Text(
                'Download the full results as a file.',
                style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
              ),
              SizedBox(height: 16.h),
              for (final entry in items) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        final navigator = Navigator.of(context);
                        navigator.pop();
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => FileDownloadView(
                              url: entry.$2.downloadUrl,
                              title: 'Download ${entry.$1}',
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cyan600),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            entry.$1,
                            style: AppTextStyles.h6.copyWith(
                              color: AppColors.cyan400,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              entry.$2.filename,
                              style: AppTextStyles.bodyxs.copyWith(
                                color: AppColors.slate400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.slate400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
