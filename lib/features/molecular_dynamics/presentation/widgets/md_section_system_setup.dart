import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/cubits/md_cubit.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MdSectionSystemSetup extends StatelessWidget {
  const MdSectionSystemSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<MdCubit>().state.config;
    final cubit = context.read<MdCubit>();

    return MdSectionCard(
      stepNumber: '1',
      title: 'System Setup',
      accentColor: AppColors.cyan400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: file pickers
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Protein PDB File', required: true),
                    _PdbFilePicker(
                      hint: 'Select protein.pdb file...',
                      fileName: config.proteinPdbName,
                      onTap: cubit.pickProteinFile,
                      onClear: cubit.clearProteinFile,
                    ),
                    SizedBox(height: 12.h),
                    const MdFieldLabel('Ligand PDB File', required: true),
                    _PdbFilePicker(
                      hint: 'Select ligand.pdb file...',
                      fileName: config.ligandPdbName,
                      onTap: cubit.pickLigandFile,
                      onClear: cubit.clearLigandFile,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Right: toggles
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    MdToggleRow(
                      label: 'Remove Waters',
                      subtitle: 'Strip existing solvent molecules',
                      value: config.removeWaters,
                      onChanged: cubit.setRemoveWaters,
                    ),
                    SizedBox(height: 32.h),
                    MdToggleRow(
                      label: 'Add Ligand Hydrogens',
                      subtitle: 'Standardize protonation states',
                      value: config.addLigandHydrogens,
                      onChanged: cubit.setAddLigandHydrogens,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Charge slider
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.slate800,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.brandBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'System Total Charge',
                      style: AppTextStyles.labelsmall.copyWith(
                        color: AppColors.authTextSecondary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.amber400,
                      size: 14.sp,
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cyan400.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: AppColors.cyan400.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        config.systemTotalCharge.toString(),
                        style: AppTextStyles.labelsmall.copyWith(
                          color: AppColors.cyan400,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.cyan400,
                    inactiveTrackColor: AppColors.slate700,
                    thumbColor: AppColors.cyan400,
                    overlayColor: AppColors.cyan400.withValues(alpha: 0.15),
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                  ),
                  child: Slider(
                    value: config.systemTotalCharge.toDouble(),
                    min: -10,
                    max: 10,
                    divisions: 20,
                    onChanged: (v) => cubit.setSystemCharge(v.round()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '-10',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                    Text(
                      '0 (NEUTRAL)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                    Text(
                      '+10',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// File picker field — shows filename when selected, placeholder when empty.
class _PdbFilePicker extends StatelessWidget {
  final String hint;
  final String fileName; // empty = nothing picked yet
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _PdbFilePicker({
    required this.hint,
    required this.fileName,
    required this.onTap,
    required this.onClear,
  });

  bool get _hasFile => fileName.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 62.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: _hasFile
              ? AppColors.cyan400.withValues(alpha: 0.08)
              : AppColors.slate800,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: _hasFile
                ? AppColors.cyan400.withValues(alpha: 0.5)
                : AppColors.brandBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _hasFile
                  ? Icons.insert_drive_file_outlined
                  : Icons.upload_file_outlined,
              color: _hasFile
                  ? AppColors.cyan400
                  : AppColors.authTextSecondary,
              size: 16.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                _hasFile ? fileName : hint,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodysmall.copyWith(
                  color: _hasFile ? AppColors.white : AppColors.slate500,
                ),
              ),
            ),
            if (_hasFile) ...[
              SizedBox(width: 8.w),
              // .pdb badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.cyan400.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '.pdb',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.cyan400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  color: AppColors.authTextSecondary,
                  size: 14.sp,
                ),
              ),
            ] else ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.slate700,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.brandBorder),
                ),
                child: Text(
                  'Browse',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
