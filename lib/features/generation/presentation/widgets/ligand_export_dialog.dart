import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/generation/data/repos/generation_repo.dart';
import 'package:ailixir/features/generation/presentation/widgets/generation_download_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class LigandExportDialog extends StatefulWidget {
  final String smiles;

  const LigandExportDialog({super.key, required this.smiles});

  @override
  State<LigandExportDialog> createState() => _LigandExportDialogState();
}

class _LigandExportDialogState extends State<LigandExportDialog> {
  String? _loadingFormat;

  static const _formats = [
    ('PDBQT', 'pdbqt', 'AutoDock Vina format'),
    ('PDB', 'pdb', 'Protein Data Bank format'),
    ('SDF', 'sdf', 'Structure-Data File format'),
  ];

  Future<void> _export(String format) async {
    setState(() => _loadingFormat = format);

    final navigator = Navigator.of(context);
    final repo = GetIt.I.get<GenerationRepo>();
    final result = await repo.exportLigand(
      smiles: widget.smiles,
      format: format,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _loadingFormat = null);
        AppToast.showErrorToast(
          context: context,
          message: 'Export failed: ${failure.message}',
        );
      },
      (data) {
        final url = data['download_url'] as String?;
        if (url != null) {
          navigator.pop();
          navigator.push(
            MaterialPageRoute(
              builder: (_) =>
                  GenerationDownloadView(url: url, title: 'Download Ligand'),
            ),
          );
        } else {
          setState(() => _loadingFormat = null);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.slate800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      content: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Ligand',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 4.h),
            Text(
              'Choose a format for the 3D structure file.',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
            SizedBox(height: 16.h),
            ..._formats.map(
              (f) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: SizedBox(
                  width: 300.w,
                  child: OutlinedButton(
                    onPressed: _loadingFormat != null
                        ? null
                        : () => _export(f.$2),
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
                        if (_loadingFormat == f.$2)
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.cyan400,
                            ),
                          )
                        else
                          Text(
                            f.$1,
                            style: AppTextStyles.h6.copyWith(
                              color: AppColors.cyan400,
                            ),
                          ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _loadingFormat == f.$2 ? 'Loading...' : f.$3,
                            style: AppTextStyles.bodyxs.copyWith(
                              color: _loadingFormat == f.$2
                                  ? AppColors.cyan400
                                  : AppColors.slate400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Center(
              child: TextButton(
                onPressed: _loadingFormat != null
                    ? null
                    : () => Navigator.of(context).pop(),
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
    );
  }
}
