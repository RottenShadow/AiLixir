import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/cubits/md_cubit.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MdSectionEquilibration extends StatelessWidget {
  const MdSectionEquilibration({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<MdCubit>().state.config;
    final cubit = context.read<MdCubit>();

    return MdSectionCard(
      stepNumber: '4',
      title: 'MD Equilibration Phase',
      accentColor: AppColors.cyan400,
      trailing: MdBadge(
        text: config.equilibrationEnabled ? 'SET ENABLED' : 'DISABLED',
        color: config.equilibrationEnabled
            ? AppColors.cyan400
            : AppColors.slate500,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job name
          const MdFieldLabel('Job Name'),
          MdTextField(
            hint: 'eq_step_01_alpha',
            initialValue: config.equilJobName,
            onChanged: cubit.setEquilJobName,
          ),
          SizedBox(height: 14.h),

          // Minimization | Timestep | Temperature | Pressure
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Minimization'),
                    MdDropdown(
                      value: config.minimizationSteps,
                      items: const [
                        '1000',
                        '5000',
                        '10000',
                        '20000',
                        '50000',
                        '100000',
                      ],
                      onChanged: (v) => cubit.setMinimizationSteps(v!),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Timestep (fs)'),
                    MdDropdown(
                      value: config.equilTimestep.toStringAsFixed(1),
                      items: const ['0.5', '1.0', '2.0', '3.0', '4.0'],
                      onChanged: (v) =>
                          cubit.setEquilTimestep(double.parse(v!)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Temperature (K)'),
                    _NumericField(
                      value: config.equilTemperature.toStringAsFixed(0),
                      onChanged: (v) {
                        final d = double.tryParse(v);
                        if (d != null) cubit.setEquilTemperature(d);
                      },
                      accentColor: AppColors.cyan400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Pressure (bar)'),
                    _NumericField(
                      value: config.equilPressure.toStringAsFixed(3),
                      onChanged: (v) {
                        final d = double.tryParse(v);
                        if (d != null) cubit.setEquilPressure(d);
                      },
                      accentColor: AppColors.cyan400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Restraint force constant slider
          Row(
            children: [
              Expanded(
                child: MdSliderRow(
                  label: 'Restraint Force Constant',
                  value: config.restraintForceConstant,
                  min: 0,
                  max: 2000,
                  divisions: 20,
                  unit: 'kJ/mol',
                  onChanged: cubit.setRestraintForceConstant,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Write traj | Write log
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Write Traj (ps)'),
                    _NumericField(
                      value: config.equilWriteTraj.toStringAsFixed(0),
                      onChanged: (v) {
                        final d = double.tryParse(v);
                        if (d != null) cubit.setEquilWriteTraj(d);
                      },
                      accentColor: AppColors.cyan400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Write Log (ps)'),
                    _NumericField(
                      value: config.equilWriteLog.toStringAsFixed(0),
                      onChanged: (v) {
                        final d = double.tryParse(v);
                        if (d != null) cubit.setEquilWriteLog(d);
                      },
                      accentColor: AppColors.cyan400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumericField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final Color accentColor;

  const _NumericField({
    required this.value,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTextStyles.bodysmall.copyWith(color: AppColors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.slate800,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.brandBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.brandBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: accentColor),
        ),
      ),
    );
  }
}
