import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/cubits/md_cubit.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_equilibration.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_force_field.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_ions.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_production.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_system_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MdViewBody extends StatelessWidget {
  const MdViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MdCubit, MdState>(
      listenWhen: (prev, next) => prev.submitStatus != next.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == MdSubmitStatus.submitted) {
          AppToast.showSuccessToast(
            context: context,
            message: 'MD job submitted. Check progress in history.',
          );
        } else if (state.submitStatus == MdSubmitStatus.failure) {
          AppToast.showErrorToast(
            context: context,
            message: state.errorMessage ?? 'Failed to submit MD simulation.',
          );
        }
      },
      child: const _FormColumn(),
    );
  }
}

class _FormColumn extends StatelessWidget {
  const _FormColumn();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────
              Text(
                'MD Lab',
                style: AppTextStyles.h1.copyWith(fontSize: 28.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                'Submit a molecular dynamics simulation of your protein-ligand complex.',
                style: AppTextStyles.bodysmall.copyWith(
                  color: AppColors.authTextSecondary,
                ),
              ),
              SizedBox(height: 24.h),

              // ── Required badge ────────────────────────────────────────
              _RequiredFilesNotice(),
              SizedBox(height: 20.h),

              // ── Sections ──────────────────────────────────────────────
              const MdSectionSystemSetup(),
              SizedBox(height: 24.h),
              const MdSectionForceField(),
              SizedBox(height: 24.h),
              const MdSectionIons(),
              SizedBox(height: 24.h),
              const MdSectionEquilibration(),
              SizedBox(height: 24.h),
              const MdSectionProduction(),
            ],
          ),
        ),
        // Sticky bottom submit bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _StickyBottomBar(),
        ),
      ],
    );
  }
}

class _RequiredFilesNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = context.watch<MdCubit>().state.config;
    final hasProtein = config.proteinPdbName.isNotEmpty;
    final hasLigand = config.ligandPdbName.isNotEmpty;
    if (hasProtein && hasLigand) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.amber400.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.amber400.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.amber400,
            size: 16.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Protein and Ligand PDB files are required to start a simulation. Upload them in Section 1.',
              style: AppTextStyles.caption.copyWith(color: AppColors.amber400),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<MdCubit>().state;
    final estimatedHours = state.config.estimatedHours;
    final isSubmitting = state.submitStatus == MdSubmitStatus.submitting;
    final hasProtein = state.config.proteinPdbName.isNotEmpty;
    final hasLigand = state.config.ligandPdbName.isNotEmpty;
    final canStart = hasProtein && hasLigand && !isSubmitting;

    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: AppColors.slate1000,
        border: Border(
          top: BorderSide(color: AppColors.brandBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          // Estimated GPU hours
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated GPU Hours',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.authTextSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: estimatedHours.toStringAsFixed(1),
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.white,
                        fontSize: 22.sp,
                      ),
                    ),
                    TextSpan(
                      text: '  hrs',
                      style: AppTextStyles.bodysmall.copyWith(
                        color: AppColors.authTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Missing-file inline hint
          if (!hasProtein || !hasLigand) ...[
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.amber400,
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  !hasProtein && !hasLigand
                      ? 'Protein & ligand PDB required'
                      : !hasProtein
                          ? 'Protein PDB required'
                          : 'Ligand PDB required',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.amber400,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
          ],
          _SubmitButton(canStart: canStart, isSubmitting: isSubmitting),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool canStart;
  final bool isSubmitting;

  const _SubmitButton({required this.canStart, required this.isSubmitting});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canStart ? () => context.read<MdCubit>().startSimulation() : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          gradient: canStart
              ? const LinearGradient(
                  colors: [Color(0xFF6B3FE4), Color(0xFF8B5CF6)],
                )
              : null,
          color: canStart ? null : AppColors.slate700,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSubmitting)
              SizedBox(
                width: 14.w,
                height: 14.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            else
              Icon(
                Icons.play_arrow_rounded,
                color: canStart ? AppColors.white : AppColors.slate500,
                size: 18.sp,
              ),
            SizedBox(width: 8.w),
            Text(
              isSubmitting ? 'Submitting...' : 'Start MD Simulation',
              style: AppTextStyles.labelmedium.copyWith(
                color: canStart ? AppColors.white : AppColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
