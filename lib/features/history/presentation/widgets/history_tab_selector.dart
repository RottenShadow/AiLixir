import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/history/presentation/cubits/history_tab_cubit/history_tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryTabSelector extends StatelessWidget {
  const HistoryTabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryTabCubit, HistoryTabState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TabChip(
                label: 'Generation',
                icon: Icons.auto_awesome,
                selected: state.selectedTab == HistoryTab.generation,
                onTap: () => context.read<HistoryTabCubit>().selectTab(HistoryTab.generation),
              ),
              SizedBox(width: 8.w),
              _TabChip(
                label: 'Docking',
                icon: Icons.hub_outlined,
                selected: state.selectedTab == HistoryTab.docking,
                onTap: () => context.read<HistoryTabCubit>().selectTab(HistoryTab.docking),
              ),
              SizedBox(width: 8.w),
              _TabChip(
                label: 'MD Simulation',
                icon: Icons.blur_on,
                selected: state.selectedTab == HistoryTab.md,
                onTap: () => context.read<HistoryTabCubit>().selectTab(HistoryTab.md),
              ),
              SizedBox(width: 8.w),
              _TabChip(
                label: 'Drug Repurposing',
                icon: Icons.biotech_outlined,
                selected: state.selectedTab == HistoryTab.drugRepurposing,
                onTap: () => context.read<HistoryTabCubit>().selectTab(HistoryTab.drugRepurposing),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.cyan900.withValues(alpha: 0.6) : AppColors.slate800,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.cyan500 : AppColors.slate700,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: selected ? AppColors.cyan400 : AppColors.slate400,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.labelsmall.copyWith(
                color: selected ? AppColors.cyan300 : AppColors.slate300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
