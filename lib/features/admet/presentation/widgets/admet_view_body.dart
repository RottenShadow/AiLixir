import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/admet/presentation/cubits/admet_cubit.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_input_form.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_logger_panel.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdmetViewBody extends StatefulWidget {
  const AdmetViewBody({super.key});

  @override
  State<AdmetViewBody> createState() => _AdmetViewBodyState();
}

class _AdmetViewBodyState extends State<AdmetViewBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdmetCubit>().reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate1000,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 0),
              child: _HeaderSection(),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: const AdmetInputForm(),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: const AdmetLoggerPanel(),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 32.h),
              child: const AdmetResults(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00D9A3), Color(0xFF00FFC8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FFC8).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.science, color: Colors.black, size: 24.sp),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF00FFC8), Color(0xFF00D9A3)],
              ).createShader(bounds),
              child: Text(
                'ADMET Prediction',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Drug Properties Analyzer',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.authTextSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
