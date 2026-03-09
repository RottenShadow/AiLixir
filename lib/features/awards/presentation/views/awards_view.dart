import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/awards/presentation/cubits/award_cubit.dart';
import 'package:ailixir/features/awards/presentation/widgets/awards_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AwardsView extends StatelessWidget {
  static const routeName = '/awards';
  final String query;
  const AwardsView({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Awards"),
        backgroundColor: AppColors.slate1000,
      ),
      body: BlocProvider(
        create: (context) => AwardsCubit()..getTestAwards(query),
        child: AwardsViewBody(),
      ),
    );
  }
}
