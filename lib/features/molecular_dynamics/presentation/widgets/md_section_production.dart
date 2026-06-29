import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/cubits/md_cubit.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MdSectionProduction extends StatelessWidget {
  const MdSectionProduction({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<MdCubit>().state.config;
    final cubit = context.read<MdCubit>();

    final totalNs = config.totalSimTime;
    final totalLabel = totalNs >= 1000
        ? '${(totalNs / 1000).toStringAsFixed(1)} ms'
        : totalNs >= 1
        ? '${totalNs.toStringAsFixed(1)} µs'
        : '${(totalNs * 1000).toStringAsFixed(0)} ns';

    return MdSectionCard(
      stepNumber: '5',
      title: 'MD Production Phase',
      accentColor: AppColors.emerald500,
      trailing: GestureDetector(
        onTap: () => cubit.setProductionEnabled(!config.productionEnabled),
        child: MdBadge(
          text: config.productionEnabled ? 'ON / PRODUCTION' : 'OFF / PRODUCTION',
          color: config.productionEnabled
              ? AppColors.emerald500
              : AppColors.slate500,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stride duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Stride Duration (ns)'),
                    _StrideDurationField(
                      value: config.strideDuration,
                      onChanged: cubit.setStrideDuration,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Number of strides
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MdFieldLabel('Number of Strides (max 10)'),
                    _NumberOfStridesField(
                      value: config.numberOfStrides,
                      onChanged: cubit.setNumberOfStrides,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Total sim time badge
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.slate800,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.brandBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL SIM TIME',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.authTextSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalLabel,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Text(
                              '(${(config.strideDuration * config.numberOfStrides).toStringAsFixed(0)} ns)',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.authTextSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Checkboxes
          Row(
            children: [
              MdCheckRow(
                label: 'Compress Trajectory (.xtc)',
                value: config.compressTrajectory,
                onChanged: (v) => cubit.setCompressTrajectory(v ?? false),
              ),
              SizedBox(width: 24.w),
              MdCheckRow(
                label: 'Calculate RMSD On-the-fly',
                value: config.calculateRmsdOnTheFly,
                onChanged: (v) => cubit.setCalculateRmsd(v ?? false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StrideDurationField extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _StrideDurationField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toStringAsFixed(0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTextStyles.bodysmall.copyWith(color: AppColors.white),
      onChanged: (v) {
        final d = double.tryParse(v);
        if (d != null) onChanged(d);
      },
      decoration: InputDecoration(
        suffixText: 'ns',
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
          borderSide: BorderSide(color: AppColors.emerald500),
        ),
      ),
    );
  }
}

class _NumberOfStridesField extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _NumberOfStridesField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: TextInputType.number,
      style: AppTextStyles.bodysmall.copyWith(color: AppColors.white),
      onChanged: (v) {
        final i = int.tryParse(v);
        if (i != null) onChanged(i.clamp(1, 10));
      },
      decoration: InputDecoration(
        hintText: '1–10',
        hintStyle: AppTextStyles.bodysmall.copyWith(color: AppColors.slate500),
        suffixText: '/ 10',
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
          borderSide: BorderSide(color: AppColors.emerald500),
        ),
      ),
    );
  }
}
