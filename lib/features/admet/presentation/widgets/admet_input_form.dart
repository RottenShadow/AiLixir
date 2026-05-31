import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/admet/presentation/cubits/admet_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdmetInputForm extends StatefulWidget {
  const AdmetInputForm({super.key});

  @override
  State<AdmetInputForm> createState() => _AdmetInputFormState();
}

class _AdmetInputFormState extends State<AdmetInputForm> {
  final TextEditingController _smilesController = TextEditingController();
  String _inputMethod = 'manual';
  String? _fileName;
  String? _error;

  @override
  void dispose() {
    _smilesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes != null) {
        final content = String.fromCharCodes(bytes);
        final lines = content
            .split(RegExp(r'[\r\n]+'))
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty && !l.startsWith('SMILES'))
            .toList();

        if (lines.length > 100) {
          setState(() {
            _error = 'File exceeds 100 row limit';
            _fileName = null;
          });
          return;
        }

        setState(() {
          _smilesController.text = lines.join('\n');
          _fileName = file.name;
          _error = null;
        });
      }
    }
  }

  void _submit() {
    final text = _smilesController.text.trim();
    if (text.isEmpty) {
      AppToast.showErrorToast(
        context: context,
        message: 'Please enter or upload at least one SMILES string',
      );
      return;
    }

    final smiles = text
        .split(RegExp(r'[\r\n,]+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (smiles.length > 100) {
      AppToast.showErrorToast(
        context: context,
        message: 'Maximum 100 SMILES allowed',
      );
      return;
    }

    context.read<AdmetCubit>().predictAdmet(smiles);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdmetCubit, AdmetState>(
      builder: (context, state) {
        final isLoading = state is AdmetLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _MethodTab(
                  label: 'Manual',
                  isSelected: _inputMethod == 'manual',
                  onTap: isLoading ? null : () => setState(() => _inputMethod = 'manual'),
                ),
                SizedBox(width: 8.w),
                _MethodTab(
                  label: 'CSV',
                  isSelected: _inputMethod == 'csv',
                  onTap: isLoading ? null : () => setState(() => _inputMethod = 'csv'),
                ),
                SizedBox(width: 8.w),
                _MethodTab(
                  label: 'TXT',
                  isSelected: _inputMethod == 'txt',
                  onTap: isLoading ? null : () => setState(() => _inputMethod = 'txt'),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (_inputMethod == 'manual')
              _ManualInput(controller: _smilesController, enabled: !isLoading)
            else
              _FileUpload(
                fileName: _fileName,
                error: _error,
                enabled: !isLoading,
                onPick: _pickFile,
              ),
            SizedBox(height: 16.h),
            if (_error != null)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColors.red500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.red500.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.red400, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        _error!,
                        style: AppTextStyles.caption.copyWith(color: AppColors.red400),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _error = null),
                        child: Icon(Icons.close, color: AppColors.red400, size: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
            _PredictButton(isLoading: isLoading, onTap: _submit),
          ],
        );
      },
    );
  }
}

class _MethodTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MethodTab({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.white.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColors.white.withOpacity(0.15)
                : AppColors.white.withOpacity(0.06),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.white : AppColors.authTextSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _ManualInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _ManualInput({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter SMILES (one per line)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.authTextSecondary,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: 12,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12.sp,
            color: const Color(0xFF88D4FF),
          ),
          decoration: InputDecoration(
            hintText: 'c1ccccc1\nCCO\nCCC',
            hintStyle: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12.sp,
              color: AppColors.slate600,
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFF00FFC8).withOpacity(0.5)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.05)),
            ),
            contentPadding: EdgeInsets.all(16.r),
          ),
        ),
      ],
    );
  }
}

class _FileUpload extends StatelessWidget {
  final String? fileName;
  final String? error;
  final bool enabled;
  final VoidCallback onPick;

  const _FileUpload({
    this.fileName,
    this.error,
    required this.enabled,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: enabled ? onPick : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40.h),
            decoration: BoxDecoration(
              color: const Color(0xFF00FFC8).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFF00FFC8).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.upload_file, size: 32.sp, color: const Color(0xFF00FFC8)),
                SizedBox(height: 12.h),
                Text(
                  'Click to upload ${fileName != null ? fileName!.split('.').last.toUpperCase() : 'CSV or TXT'} file',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: const Color(0xFF00FFC8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'or drag and drop',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.authTextSecondary.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (fileName != null) ...[
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFF00FFC8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16.sp, color: const Color(0xFF00FFC8)),
                SizedBox(width: 8.w),
                Text(
                  '$fileName loaded',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PredictButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _PredictButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isLoading
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF00FFC8), Color(0xFF00D9A3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLoading ? AppColors.white.withOpacity(0.08) : null,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF00FFC8).withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.slate400,
                ),
              )
            else
              Icon(Icons.science, size: 18.sp, color: Colors.black),
            SizedBox(width: 8.w),
            Text(
              isLoading ? 'Predicting ADMET...' : 'Predict ADMET Properties',
              style: AppTextStyles.labelmedium.copyWith(
                color: isLoading ? AppColors.slate400 : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
