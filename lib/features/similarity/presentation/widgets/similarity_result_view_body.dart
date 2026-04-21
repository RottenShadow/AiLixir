import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/similarity/cubits/similarity_result_cubit.dart';
import 'package:ailixir/features/similarity/data/models/similarity_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimilarityResultViewBody extends StatelessWidget {
  const SimilarityResultViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimilarityResultCubit, SimilarityResultState>(
      builder: (context, state) {
        if (state is SimilarityResultError) {
          return Center(child: Text("Error: Failed to Fetch"));
        } else if (state is SimilarityResultSuccess) {
          return _body(state.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _body(SimilarityResultModel data) {
    return ListView.builder(
      itemCount: data.total_results,
      itemBuilder: (c, idx) {
        return _similarityCard(
          onTap: () {},
          compoundName: data.results[idx].name,
          compoundWork: data.results[idx].explanation,
          compoundImage: data.results[idx].imageUrl,
        );
      },
    );
  }

  Widget _compoundImage(String image) {
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

  Widget _similarityCard({
    required void Function() onTap,
    String compoundName = "DEFAULT_SCIENTIST_NAME",
    String compoundField = "DEFAULT_FIELD",
    String compoundWork = "-----",
    String compoundImage =
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
              _compoundImage(compoundImage),
              SizedBox(
                width: 0.35.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(compoundName, style: AppTextStyles.h1),
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
                    Text(compoundWork, style: AppTextStyles.bodymedium),
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
