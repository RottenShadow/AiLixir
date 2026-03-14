import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/presentation/widgets/single_award_view_body.dart';
import 'package:flutter/material.dart';

class SingleAwardView extends StatelessWidget {
  final AwardModel award;
  static const routeName = "/singleaward";
  const SingleAwardView({super.key, required this.award});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(award.name),
        backgroundColor: AppColors.slate1000,
      ),
      body: SingleAwardViewBody(award: award),
    );
  }
}
