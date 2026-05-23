import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/widgets/award_card.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/data/models/award_package.dart';
import 'package:ailixir/features/awards/presentation/cubits/award_cubit.dart';
import 'package:ailixir/features/awards/presentation/views/single_award_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleScientistViewBody extends StatelessWidget {
  final List<AwardModel> awards;
  const SingleScientistViewBody({super.key, required this.awards});
  @override
  Widget build(BuildContext context) {
    return _awardGrid(context);
  }

  Widget _awardGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 0.02.sw,
      mainAxisSpacing: 0.06.sh,
      childAspectRatio: 1.777,
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: 0.05.sw,
        vertical: 0.05.sh,
      ),
      children: List.generate(awards.length, (index) {
        return awardCard(
          awards[index],
          context,
          AppColors.awardNameGradientTop,
          Icons.emoji_events,
          20,
          () {
            context.navigateTo(
              SingleAwardView.routeName,
              arguments: AwardPackage(
                award: awards[index],
                cubit: AwardsCubit(),
              ),
            );
          },
        );
      }),
    );
  }
}
