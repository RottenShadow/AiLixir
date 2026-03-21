import 'dart:math';

import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/award_card.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/data/models/award_package.dart';
import 'package:ailixir/features/awards/presentation/cubits/award_cubit.dart';
import 'package:ailixir/features/awards/presentation/views/single_award_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AwardsViewBody extends StatelessWidget {
  const AwardsViewBody({super.key});

  static final List<Color> _colors = [
    Color(0xFF60a5fa), //blue
    Color(0xFFd4af37), //yellow
    Color(0xFF34d399), //green
    Color(0xFFc084fc), //purple
    Color(0xFFee6c80), //red
    Color(0xFFe8970d), //orange
  ];
  static final List<IconData> _icons = [
    Icons.badge,
    Icons.science,
    Icons.check_rounded,
    Icons.auto_awesome_rounded,
    Icons.public_rounded,
    Icons.medical_information,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AwardsCubit, AwardState>(
      builder: (context, state) {
        if (state is AwardLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AwardSuccess) {
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 0.02.sw,
            mainAxisSpacing: 0.06.sh,
            childAspectRatio: 1.777,
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 0.05.sw,
              vertical: 0.05.sh,
            ),
            children: List.generate(state.awards.length, (index) {
              Color categoryColor = _colors[Random().nextInt(_colors.length)];
              IconData categoryIcon = _icons[Random().nextInt(_icons.length)];
              return awardCard(
                state.awards[index],
                context,
                categoryColor,
                categoryIcon,
                20,
                () {
                  context.navigateTo(
                    SingleAwardView.routeName,
                    arguments: AwardPackage(
                      award: state.awards[index],
                      cubit: context.read<AwardsCubit>(),
                    ),
                  );
                },
              );
            }),
          );
        } else {
          final cubit = context.read<AwardsCubit>();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ERROR: FAILED TO FETCH AWARDS",
                  style: TextStyle(color: AppColors.red800),
                ),
                IconButton(
                  onPressed: () {
                    cubit.getTestAwards();
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void stuff(BuildContext context) {}
}
