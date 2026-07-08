import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/quick/dr_quick_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Quick Mode form — disease name input + Get Targets button, side by side.
class DrQuickForm extends StatefulWidget {
  const DrQuickForm({super.key});

  @override
  State<DrQuickForm> createState() => _DrQuickFormState();
}

class _DrQuickFormState extends State<DrQuickForm> {
  final TextEditingController _diseaseController = TextEditingController();

  @override
  void dispose() {
    _diseaseController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final disease = _diseaseController.text.trim();
    if (disease.isEmpty) {
      AppToast.showErrorToast(
        context: context,
        message: 'Disease name is required!',
      );
      return;
    }
    context.read<DrQuickCubit>().getTargets(disease);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrQuickCubit, DrQuickState>(
      builder: (context, state) {
        final isLoading = state is DrQuickPolling;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _DiseaseInput(
                controller: _diseaseController,
                enabled: !isLoading,
              ),
            ),
            SizedBox(width: 16.w),
            _GetTargetsButton(
              isLoading: isLoading,
              onTap: () => _submit(context),
            ),
          ],
        );
      },
    );
  }
}

// ── Disease input ─────────────────────────────────────────────────────────────

class _DiseaseInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _DiseaseInput({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Disease Name',
              style: AppTextStyles.labelmedium.copyWith(
                color: AppColors.authTextSecondary,
              ),
            ),
            Text(
              ' *',
              style: AppTextStyles.labelmedium.copyWith(
                color: AppColors.red500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          enabled: enabled,
          style: AppTextStyles.bodysmall.copyWith(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'e.g. Type 2 Diabetes',
            hintStyle: AppTextStyles.bodysmall.copyWith(
              color: AppColors.slate500,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 18.sp,
              color: AppColors.slate500,
            ),
            filled: true,
            fillColor: AppColors.slate900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.brandBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.brandBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: AppColors.cyan400,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: AppColors.brandBorder.withOpacity(0.4),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Get Targets button ────────────────────────────────────────────────────────

class _GetTargetsButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _GetTargetsButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54.h,
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        decoration: BoxDecoration(
          gradient: isLoading
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF0891B2), AppColors.cyan400],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLoading ? AppColors.slate700 : null,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: AppColors.cyan400.withOpacity(0.25),
                    blurRadius: 12,
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
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(Icons.radar, size: 18.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              isLoading ? 'Fetching Targets...' : 'Get Targets',
              style: AppTextStyles.labelmedium.copyWith(
                color: isLoading ? AppColors.slate400 : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
