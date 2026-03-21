import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/scientists/presentation/cubits/scientist_credit_cubit.dart';
import 'package:ailixir/features/scientists/presentation/widgets/scientist_credits_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScientistCreditView extends StatelessWidget {
  static const routeName = '/credits';
  const ScientistCreditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Esteemed Scientists"),
        backgroundColor: AppColors.slate1000,
      ),
      body: BlocProvider(
        create: (context) => ScientistCreditCubit()..getTestScientists(),
        child: ScientistCreditsViewBody(),
      ),
    );
  }
}
