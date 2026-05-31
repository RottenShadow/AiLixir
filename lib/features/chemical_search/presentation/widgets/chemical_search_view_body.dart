import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/chemical_search/presentation/cubits/chemical_search_cubit.dart';
import 'package:ailixir/features/chemical_search/presentation/widgets/tab_page.dart';

class ChemicalSearchViewBody extends StatelessWidget {
  final ChemicalSearchCubit retrievalCubit;
  final ChemicalSearchCubit fullRagCubit;

  const ChemicalSearchViewBody({
    super.key,
    required this.retrievalCubit,
    required this.fullRagCubit,
  });

  @override
  Widget build(BuildContext context) {
    return _ChemicalSearchTabs(
      retrievalCubit: retrievalCubit,
      fullRagCubit: fullRagCubit,
    );
  }
}

class _ChemicalSearchTabs extends StatefulWidget {
  final ChemicalSearchCubit retrievalCubit;
  final ChemicalSearchCubit fullRagCubit;

  const _ChemicalSearchTabs({
    required this.retrievalCubit,
    required this.fullRagCubit,
  });

  @override
  State<_ChemicalSearchTabs> createState() => _ChemicalSearchTabsState();
}

class _ChemicalSearchTabsState extends State<_ChemicalSearchTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 24.h),
          _buildTabBar(),
          SizedBox(height: 20.h),
          IndexedStack(
            index: _selectedTab,
            children: [
              TabPage(cubit: widget.retrievalCubit),
              TabPage(cubit: widget.fullRagCubit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.search, color: AppColors.brandBlue, size: 22.sp),
        SizedBox(width: 10.w),
        Text(
          'Molecular Similarity Search',
          style: AppTextStyles.h2.copyWith(color: AppColors.white),
        ),
        SizedBox(width: 12.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: AppColors.brandBlue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: AppColors.brandBlue.withOpacity(0.3)),
          ),
          child: Text(
            'FAISS-IVF',
            style: AppTextStyles.labelsmall.copyWith(
              color: AppColors.brandBlue,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabOption(
            label: 'Retrieval',
            icon: Icons.bolt,
            isSelected: _selectedTab == 0,
            onTap: () => setState(() => _selectedTab = 0),
          ),
          SizedBox(width: 4.w),
          _TabOption(
            label: 'Full RAG',
            icon: Icons.psychology,
            isSelected: _selectedTab == 1,
            onTap: () => setState(() => _selectedTab = 1),
          ),
        ],
      ),
    );
  }
}

class _TabOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlue.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: isSelected ? AppColors.brandBlue : AppColors.slate500,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.labelsmall.copyWith(
                color: isSelected ? AppColors.brandBlue : AppColors.slate400,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
