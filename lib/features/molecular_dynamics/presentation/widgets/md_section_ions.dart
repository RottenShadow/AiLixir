import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/cubits/md_cubit.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MdSectionIons extends StatelessWidget {
  const MdSectionIons({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<MdCubit>().state.config;
    final cubit = context.read<MdCubit>();

    return MdSectionCard(
      stepNumber: '3',
      title: 'Ions & Ionic Strength',
      accentColor: AppColors.teal500,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MdFieldLabel('Salt Type'),
                MdDropdown(
                  value: config.saltType,
                  items: const ['NaCl', 'KCl'],
                  onChanged: (v) => cubit.setSaltType(v!),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MdFieldLabel('Concentration (M)'),
                _ConcentrationField(
                  value: config.concentration,
                  onChanged: cubit.setConcentration,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConcentrationField extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _ConcentrationField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTextStyles.bodysmall.copyWith(color: AppColors.white),
      onChanged: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null) onChanged(parsed);
      },
      decoration: InputDecoration(
        hintText: '0.15',
        hintStyle: AppTextStyles.bodysmall.copyWith(color: AppColors.slate500),
        suffixText: 'Molarity',
        suffixStyle: AppTextStyles.caption.copyWith(
          color: AppColors.authTextSecondary,
        ),
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
          borderSide: BorderSide(color: AppColors.teal500),
        ),
      ),
    );
  }
}
