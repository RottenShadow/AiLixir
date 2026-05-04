import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/full/dr_full_cubit.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_tag_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full Screening Mode form — two-row compact grid layout.
class DrFullForm extends StatefulWidget {
  const DrFullForm({super.key});

  @override
  State<DrFullForm> createState() => _DrFullFormState();
}

class _DrFullFormState extends State<DrFullForm> {
  final TextEditingController _diseaseController = TextEditingController();
  List<String> _knownDrugs = [];
  List<String> _extraSmiles = [];
  int _topK = 5;

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
    context.read<DrFullCubit>().screenDrugs(
      diseaseName: disease,
      knownDrugs: _knownDrugs,
      extraSmiles: _extraSmiles,
      topK: _topK,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrFullCubit, DrFullState>(
      builder: (context, state) {
        final isLoading = state is DrFullLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Disease | Known Drugs | Extra SMILES
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: _DiseaseInput(
                      controller: _diseaseController,
                      enabled: !isLoading,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Flexible(
                    flex: 3,
                    child: DrTagInput(
                      label: 'Known Drugs',
                      hint: 'e.g. Metformin, Insulin...',
                      tags: _knownDrugs,
                      accentColor: const Color(0xFF8B5CF6),
                      onTagsChanged: (tags) =>
                          setState(() => _knownDrugs = tags),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Flexible(
                    flex: 3,
                    child: DrTagInput(
                      label: 'Extra SMILES',
                      hint: 'Paste SMILES string...',
                      tags: _extraSmiles,
                      accentColor: const Color(0xFF10B981),
                      onTagsChanged: (tags) =>
                          setState(() => _extraSmiles = tags),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Row 2: Top-K slider + Run button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _TopKInput(
                    value: _topK,
                    enabled: !isLoading,
                    onChanged: (v) => setState(() => _topK = v),
                  ),
                ),
                SizedBox(width: 24.w),
                _RunScreeningButton(
                  isLoading: isLoading,
                  onTap: () => _submit(context),
                ),
              ],
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
                color: Color(0xFF8B5CF6),
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

// ── Top-K slider ──────────────────────────────────────────────────────────────

class _TopKInput extends StatelessWidget {
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _TopKInput({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Top-K',
          style: AppTextStyles.labelmedium.copyWith(
            color: AppColors.authTextSecondary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF10B981),
              inactiveTrackColor: AppColors.slate700,
              thumbColor: const Color(0xFF10B981),
              overlayColor: const Color(0xFF10B981).withOpacity(0.15),
              trackHeight: 4,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.r),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: enabled ? (v) => onChanged(v.round()) : null,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 36.w,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              '$value',
              style: AppTextStyles.labelmedium.copyWith(
                color: const Color(0xFF10B981),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Run Screening button ──────────────────────────────────────────────────────

class _RunScreeningButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _RunScreeningButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        decoration: BoxDecoration(
          gradient: isLoading
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF6B3FE4), Color(0xFF8B5CF6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLoading ? AppColors.slate700 : null,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
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
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(Icons.play_circle_fill, size: 18.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              isLoading ? 'Running AI Screening...' : 'Run Screening',
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
