import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:ailixir/features/scientists/data/models/scientist_package.dart';
import 'package:ailixir/features/scientists/presentation/cubits/scientist_credit_cubit.dart';
import 'package:ailixir/features/scientists/presentation/views/single_scientist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class ScientistCreditsViewBody extends StatefulWidget {
  const ScientistCreditsViewBody({super.key});
  @override
  State<StatefulWidget> createState() => _ScientistCreditState();
}

class _ScientistCreditState extends State<ScientistCreditsViewBody> {
  late ScrollController _scrollController;
  late int _currentScientist;

  @override
  void initState() {
    _scrollController = ScrollController();
    _currentScientist = 0;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScientistCreditCubit, ScientistCreditState>(
      builder: (context, state) {
        if (state is ScientistCreditError) {
          return Center(child: Text("Error: Failed to Fetch"));
        } else if (state is ScientistCreditSuccess) {
          return _body(state.res);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _body(List<ScientistModel> scientists) {
    return Stack(
      children: [
        ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsGeometry.all(0.05.sw),
          physics: const NeverScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: scientists.length,
          separatorBuilder: (context, index) {
            return SizedBox(width: 0.05.sw);
          },
          itemBuilder: (context, idx) {
            return _scientistCard(
              onTap: () {
                context.navigateTo(
                  SingleScientistView.routeName,
                  arguments: ScientistPackage(
                    scientist: scientists[idx],
                    cubit: context.read<ScientistCreditCubit>(),
                  ),
                );
              },
              scientistName: scientists[idx].name,
              scientistImage: scientists[idx].imageUrl,
              scientistField: scientists[idx].field,
              scientistWork: scientists[idx].shortBio,
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _scrollButton(Icons.arrow_left, () {
              _currentScientist = max(0, (_currentScientist - 1));
              _scrollController.animateTo(
                0.8.sw * _currentScientist,
                duration: Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            }),
            _scrollButton(Icons.arrow_right, () {
              _currentScientist = min(_currentScientist + 1, 2);
              _scrollController.animateTo(
                0.8.sw * _currentScientist,
                duration: Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _scrollButton(IconData icon, void Function() onTap) {
    return IconButton(
      onPressed: onTap,
      color: AppColors.red500,
      splashColor: AppColors.white,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(10),
        backgroundColor: AppColors.brandBlue.withAlpha(53),
        foregroundColor: Colors.white,
      ),
      icon: Icon(icon),
    );
  }

  static const String _defaultAchievement =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Widget _scientistImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(12.r),
      child: Image.network(
        image,
        width: 0.4.sw,
        fit: BoxFit.contain,
        alignment: Alignment.topLeft,
      ),
    );
  }

  Widget _fieldPill(String field) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.brandBlue.withAlpha(53),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brandBlue),
      ),
      child: Text(
        field,
        style: TextStyle(color: AppColors.brandBlue, fontSize: 10),
      ),
    );
  }

  Widget _scientistCard({
    required void Function() onTap,
    String scientistName = "DEFAULT_SCIENTIST_NAME",
    String scientistField = "DEFAULT_FIELD",
    String scientistWork = _defaultAchievement,
    String scientistImage =
        "https://media.gettyimages.com/id/57520719/photo/doctor-holding-note-pad-posing-in-studio-portrait.jpg?s=612x612&w=0&k=20&c=cxnjilkTFucKBOneZYY6xZY7sEWTLvKLXzyWRgjJCqE=",
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 0.8.sw,
        child: Card(
          color: AppColors.brandBlue.withAlpha(26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12.r),
            side: BorderSide(color: AppColors.brandBorder, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 0,
            children: [
              _scientistImage(scientistImage),
              SizedBox(
                width: 0.35.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: _fieldPill(scientistField),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(scientistName, style: AppTextStyles.h1),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.authTextSecondary.withAlpha(153),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Short Biography',
                            style: AppTextStyles.labelsmall.copyWith(
                              color: AppColors.authTextSecondary.withValues(
                                alpha: 0.6,
                              ),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.authTextSecondary.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                    Text(scientistWork, style: AppTextStyles.bodymedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
