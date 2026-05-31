import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/chemical_search/presentation/widgets/chemical_search_shared.dart';

class SearchForm extends StatelessWidget {
  final TextEditingController smilesController;
  final TextEditingController topKController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback? onReset;

  const SearchForm({
    super.key,
    required this.smilesController,
    required this.topKController,
    required this.isLoading,
    required this.onSubmit,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: AppColors.cyan400, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'Search Configuration',
                style: AppTextStyles.h4.copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _SmilesInputField(
                  controller: smilesController,
                  enabled: !isLoading,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                flex: 1,
                child: _TopKField(
                  controller: topKController,
                  enabled: !isLoading,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _SearchButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : onSubmit,
            onReset: onReset,
          ),
        ],
      ),
    );
  }
}

class _SmilesInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _SmilesInputField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel('SMILES Input'),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: 2,
          style: AppTextStyles.bodymedium.copyWith(
            color: AppColors.white,
            fontFamily: 'monospace',
          ),
          decoration: inputDecoration(
            hint: 'e.g., CCO, c1ccccc1, CC(=O)O',
          ),
          onFieldSubmitted: (_) {},
        ),
        SizedBox(height: 4.h),
        Text(
          'Enter a valid SMILES string to find similar compounds.',
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _TopKField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _TopKField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel('Top K'),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: inputDecoration(hint: '3'),
        ),
        SizedBox(height: 4.h),
        Text(
          'Max: 100',
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _SearchButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final VoidCallback? onReset;

  const _SearchButton({
    required this.isLoading,
    required this.onPressed,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    if (onReset != null) {
      return _buildBtn(
        label: 'Clear Results',
        icon: Icons.refresh,
        color: AppColors.slate600,
        onPressed: onReset,
      );
    }

    return _buildBtn(
      label: isLoading ? 'Searching...' : 'Search Similar Compounds',
      icon: isLoading ? null : Icons.search,
      color: isLoading ? AppColors.slate600 : AppColors.brandBlue,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  Widget _buildBtn({
    required String label,
    IconData? icon,
    required Color color,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 44.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 14.w,
                height: 14.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 8.w),
            ] else if (icon != null) ...[
              Icon(icon, color: AppColors.white, size: 16.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: AppTextStyles.labellarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
