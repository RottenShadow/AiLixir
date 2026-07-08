import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/cubits/md_cubit.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MdSectionForceField extends StatelessWidget {
  const MdSectionForceField({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<MdCubit>().state.config;
    final cubit = context.read<MdCubit>();

    return MdSectionCard(
      stepNumber: '2',
      title: 'Force Field & Solvation',
      accentColor: AppColors.cyan400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Three dropdowns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Protein Force Field'),
                    MdDropdown(
                      value: config.proteinForceField,
                      items: const ['ff19SB', 'ff14SB'],
                      onChanged: (v) => cubit.setProteinForceField(v!),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Ligand Force Field'),
                    MdDropdown(
                      value: config.ligandForceField,
                      items: const ['GAFF2'],
                      onChanged: (v) => cubit.setLigandForceField(v!),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Water Model'),
                    MdDropdown(
                      value: config.waterModel,
                      items: const ['TIP3P', 'OPC'],
                      onChanged: (v) => cubit.setWaterModel(v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Box size slider
          MdSliderRow(
            label: 'Box Size Padding (Å)',
            value: config.boxSizePadding,
            min: 10,
            max: 20,
            divisions: 10,
            unit: 'Å',
            onChanged: cubit.setBoxSizePadding,
          ),
        ],
      ),
    );
  }
}
