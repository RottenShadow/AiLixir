import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/drug_repurposing/domain/enum/dr_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrModeToggle extends StatelessWidget {
  final DrugRepurposingMode selectedMode;
  final ValueChanged<DrugRepurposingMode> onModeChanged;

  const DrModeToggle({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            label: 'Quick Mode',
            icon: Icons.flash_on_rounded,
            isSelected: selectedMode == DrugRepurposingMode.quick,
            accentColor: AppColors.cyan400,
            onTap: () => onModeChanged(DrugRepurposingMode.quick),
          ),
          SizedBox(width: 4.w),
          _ModeButton(
            label: 'Full Screening',
            icon: Icons.science_rounded,
            isSelected: selectedMode == DrugRepurposingMode.full,
            accentColor: AppColors.cyan400,
            onTap: () => onModeChanged(DrugRepurposingMode.full),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          border: isSelected
              ? Border.all(color: accentColor.withOpacity(0.5))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15.sp,
              color: isSelected ? accentColor : AppColors.authTextSecondary,
            ),
            SizedBox(width: 7.w),
            Text(
              label,
              style: AppTextStyles.labelmedium.copyWith(
                color: isSelected ? accentColor : AppColors.authTextSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
