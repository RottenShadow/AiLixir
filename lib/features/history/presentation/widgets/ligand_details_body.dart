import 'package:ailixir/core/entities/ligand_details_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/error/custom_failure_body.dart';
import 'package:ailixir/features/history/presentation/cubits/ligand_details_cubit/ligand_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LigandDetailsBody extends StatelessWidget {
  final LigandEntity ligand;
  const LigandDetailsBody({super.key, required this.ligand});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LigandDetailsCubit, LigandDetailsState>(
      builder: (context, state) {
        if (state is LigandDetailsError) {
          return Center(
            child: CustomFailureBody(
              icon: Icons.error_outline,
              msg: state.message,
              actionLabel: 'Try Again',
              onAction: () => context
                  .read<LigandDetailsCubit>()
                  .loadDetails(ligand.id),
            ),
          );
        }

        final isLoading =
            state is LigandDetailsLoading || state is LigandDetailsInitial;
        final details = state is LigandDetailsLoaded
            ? state.details
            : LigandDetailsEntity.createFakeData(ligand.id);

        return Skeletonizer(
          enabled: isLoading,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.slate1000,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comprehensive Compound Analysis Report',
                      style: AppTextStyles.h5.copyWith(color: AppColors.white),
                    ),
                    Text(
                      ligand.candidateName.toUpperCase(),
                      style: AppTextStyles.bodyxs.copyWith(
                        color: AppColors.cyan400,
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _CompoundIdentityCard(smiles: details.smiles),
                              SizedBox(height: 12.h),
                              _DockingCard(details: details),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Middle column
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _MedChemCard(details: details),
                              SizedBox(height: 12.h),
                              _ReosFiltersCard(details: details),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Right column
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _GlobalSummaryCard(details: details),
                              SizedBox(height: 12.h),
                              _StructureValidityCard(details: details),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Cards ────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.slate400, size: 14.sp),
              SizedBox(width: 6.w),
              Text(
                title,
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.slate300,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _CompoundIdentityCard extends StatelessWidget {
  final String smiles;
  const _CompoundIdentityCard({required this.smiles});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '1. Compound Identity',
      icon: Icons.science_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SMILES NOTATION',
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.slate900,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              smiles,
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.slate200,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockingCard extends StatelessWidget {
  final LigandDetailsEntity details;
  const _DockingCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '9. Docking & Scoring',
      icon: Icons.hub_outlined,
      child: Column(
        children: [
          _DetailRow(
            label: 'Vina Score',
            value: '${details.vinaScore} kcal/mol',
          ),
          _DetailRow(label: 'QED Score', value: details.qedScore.toString()),
        ],
      ),
    );
  }
}

class _MedChemCard extends StatelessWidget {
  final LigandDetailsEntity details;
  const _MedChemCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '5. MedChem Properties',
      icon: Icons.biotech_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _DetailRow(
                  label: 'Valid/Connected',
                  value: details.validConnected ? 'Valid' : 'Invalid',
                  valueColor: details.validConnected
                      ? AppColors.emerald400
                      : AppColors.red400,
                ),
              ),
              Expanded(
                child: _DetailRow(
                  label: 'LogP',
                  value: details.logP.toString(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _DetailRow(
                  label: 'Rot. Bonds',
                  value: details.rotBonds.toString(),
                ),
              ),
              Expanded(
                child: _DetailRow(label: 'TPSA', value: '${details.tpsa} Å²'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReosFiltersCard extends StatelessWidget {
  final LigandDetailsEntity details;
  const _ReosFiltersCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '8. REOS Filters',
      icon: Icons.filter_alt_outlined,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          _FilterBadge(label: 'Glaxo', pass: details.glaxo),
          _FilterBadge(label: 'PAINS', pass: details.pains),
          _FilterBadge(label: 'MLSMR', pass: details.mlsmr),
        ],
      ),
    );
  }
}

class _GlobalSummaryCard extends StatelessWidget {
  final LigandDetailsEntity details;
  const _GlobalSummaryCard({required this.details});

  @override
  Widget build(BuildContext context) {
    // Determine overall quality
    final passCount = [
      details.glaxo,
      details.pains,
      details.mlsmr,
      details.validConnected,
      details.structureLoaded,
      details.sanitization,
    ].where((v) => v).length;
    final total = 6;
    final isGood = passCount >= 5;

    return _SectionCard(
      title: '10. Global Summary',
      icon: Icons.bar_chart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Quality',
                style: AppTextStyles.bodysmall.copyWith(
                  color: AppColors.slate400,
                ),
              ),
              Text(
                isGood ? 'GOOD LIGAND' : 'POOR LIGAND',
                style: AppTextStyles.labelsmall.copyWith(
                  color: isGood ? AppColors.emerald400 : AppColors.red400,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '$passCount/$total',
            style: AppTextStyles.h2.copyWith(
              color: isGood ? AppColors.emerald400 : AppColors.red400,
            ),
          ),
          Text(
            'Checks Passed',
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
          ),
        ],
      ),
    );
  }
}

class _StructureValidityCard extends StatelessWidget {
  final LigandDetailsEntity details;
  const _StructureValidityCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '2. Structure Validity',
      icon: Icons.check_circle_outline,
      child: Column(
        children: [
          _ValidityRow(label: 'mol_pred_loaded', pass: details.structureLoaded),
          _ValidityRow(
            label: 'mol_cond_loaded',
            pass: details.conformationLoaded,
          ),
          _ValidityRow(label: 'sanitization', pass: details.sanitization),
          _ValidityRow(
            label: 'all_atoms_connected',
            pass: details.allAtomsConnected,
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
          ),
          Text(
            value,
            style: AppTextStyles.bodysmall.copyWith(
              color: valueColor ?? AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidityRow extends StatelessWidget {
  final String label;
  final bool pass;
  const _ValidityRow({required this.label, required this.pass});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
          ),
          _FilterBadge(label: pass ? 'Pass' : 'Fail', pass: pass),
        ],
      ),
    );
  }
}

class _FilterBadge extends StatelessWidget {
  final String label;
  final bool pass;
  const _FilterBadge({required this.label, required this.pass});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: pass
            ? AppColors.emerald900.withValues(alpha: 0.4)
            : AppColors.red900.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelsmall.copyWith(
          color: pass ? AppColors.emerald400 : AppColors.red400,
        ),
      ),
    );
  }
}
