import 'dart:io';

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
  String? _filePath;

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
      List<int>? bytes = file.bytes;
      if (bytes == null) {
        try {
          bytes = await File(file.path!).readAsBytes();
        } catch (_) {
          return;
        }
      }

      final content = String.fromCharCodes(bytes);
      final lines = content
          .split(RegExp(r'[\r\n]+'))
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && !l.startsWith('SMILES'))
          .toList();

      if (lines.length > 100) {
        AppToast.showErrorToast(
          context: context,
          message: 'File exceeds maximum 100 rows limit',
        );
        return;
      }

      setState(() {
        _filePath = file.path;
        _fileName = file.name;
      });
    }
  }

  void _submit() {
    if (_inputMethod == 'manual') {
      final smiles = _smilesController.text
          .trim()
          .split(RegExp(r'[\r\n,]+'))
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      if (smiles.isEmpty) {
        AppToast.showErrorToast(
          context: context,
          message: 'Please enter at least one SMILES string',
        );
        return;
      }

      if (smiles.length > 6) {
        AppToast.showErrorToast(
          context: context,
          message: 'Maximum 6 SMILES allowed',
        );
        return;
      }

      context.read<AdmetCubit>().predictAdmet(smiles);
    } else {
      if (_filePath == null) {
        AppToast.showErrorToast(
          context: context,
          message: 'Please upload a file with SMILES data',
        );
        return;
      }

      context.read<AdmetCubit>().predictAdmetFromFile(_filePath!);
    }
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
                  label: 'File',
                  isSelected: _inputMethod == 'file',
                  onTap: isLoading ? null : () => setState(() => _inputMethod = 'file'),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (_inputMethod == 'manual')
              _ManualInput(controller: _smilesController, enabled: !isLoading)
            else
              _FileUpload(
                fileName: _fileName,
                enabled: !isLoading,
                onPick: _pickFile,
                onRemove: () => setState(() {
                  _fileName = null;
                  _filePath = null;
                }),
              ),
            SizedBox(height: 16.h),
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
          'Enter SMILES (separate by comma or new line, max 6)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.authTextSecondary,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: 8,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12.sp,
            color: const Color(0xFF88D4FF),
          ),
          decoration: InputDecoration(
            hintText: 'c1ccccc1, CCO, CCC',
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
              borderSide: BorderSide(color: AppColors.cyan400.withOpacity(0.5)),
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
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  const _FileUpload({
    this.fileName,
    required this.enabled,
    required this.onPick,
    this.onRemove,
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
              color: AppColors.cyan400.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.cyan400.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.upload_file, size: 32.sp, color: AppColors.cyan400),
                SizedBox(height: 12.h),
                Text(
                  'Click to upload CSV or TXT file',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.cyan400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'or drag and drop (max 100 rows)',
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
              color: AppColors.cyan400.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16.sp, color: AppColors.cyan400),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '$fileName loaded',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.authTextSecondary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(Icons.close, size: 16.sp, color: AppColors.authTextSecondary),
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
                  colors: [AppColors.cyan400, AppColors.cyan400],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLoading ? AppColors.white.withOpacity(0.08) : null,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: AppColors.cyan400.withOpacity(0.3),
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
