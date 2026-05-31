import 'package:ailixir/features/admet/presentation/cubits/admet_cubit.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdmetView extends StatelessWidget {
  const AdmetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdmetCubit(),
      child: const Scaffold(body: AdmetViewBody()),
    );
  }
}
