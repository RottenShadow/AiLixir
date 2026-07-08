import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/history/presentation/cubits/drug_repurposing_cubit/drug_repurposing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrugRepurposingSubTabSelector extends StatelessWidget {
  final DrugRepurposingSubTab selected;
  final ValueChanged<DrugRepurposingSubTab> onChanged;

  const DrugRepurposingSubTabSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SubTabChip(
          label: 'Targets',
          selected: selected == DrugRepurposingSubTab.targets,
          onTap: () => onChanged(DrugRepurposingSubTab.targets),
        ),
        SizedBox(width: 8.w),
        _SubTabChip(
          label: 'Screening',
          selected: selected == DrugRepurposingSubTab.screen,
          onTap: () => onChanged(DrugRepurposingSubTab.screen),
        ),
      ],
    );
  }
}

class _SubTabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SubTabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.cyan900.withValues(alpha: 0.5) : AppColors.slate800,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.cyan500 : AppColors.slate700,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelsmall.copyWith(
            color: selected ? AppColors.cyan300 : AppColors.slate400,
          ),
        ),
      ),
    );
  }
}
