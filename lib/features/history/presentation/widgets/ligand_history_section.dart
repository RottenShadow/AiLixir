import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/history/presentation/cubits/see_all_cubit/see_all_cubit.dart';
import 'package:ailixir/features/history/presentation/views/ligand_details_view.dart';
import 'package:ailixir/features/history/presentation/views/ligand_see_all_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LigandHistorySection extends StatelessWidget {
  final List<LigandEntity> ligands;
  const LigandHistorySection({super.key, required this.ligands});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science_outlined,
                  color: AppColors.cyan400,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Ligand Generation History',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => LigandSeeAllCubit()..loadFirstPage(),
                          child: const LigandSeeAllView(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'See All',
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.cyan400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...ligands.map((l) => _LigandCard(ligand: l)),
      ],
    );
  }
}

class _LigandCard extends StatelessWidget {
  final LigandEntity ligand;
  const _LigandCard({required this.ligand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(LigandDetailsView.routeName, extra: ligand),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.slate800,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.brandBorder),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.slate700,
                borderRadius: BorderRadius.circular(6.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'SM',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.slate300,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ligand.candidateName,
                    style: AppTextStyles.h6.copyWith(color: AppColors.white),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    ligand.smiles,
                    style: AppTextStyles.bodyxs.copyWith(
                      color: AppColors.slate400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Analyze button
            OutlinedButton.icon(
              onPressed: () =>
                  context.push(LigandDetailsView.routeName, extra: ligand),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.cyan600),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(
                Icons.remove_red_eye_outlined,
                color: AppColors.cyan400,
                size: 14.sp,
              ),
              label: Text(
                'Analyze',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.cyan400,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Download button
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.slate600),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(
                Icons.download_outlined,
                color: AppColors.slate300,
                size: 14.sp,
              ),
              label: Text(
                'Download .mol',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.slate300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
