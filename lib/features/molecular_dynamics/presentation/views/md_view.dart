import 'package:ailixir/features/molecular_dynamics/presentation/cubits/md_cubit.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/widgets/md_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MDView extends StatelessWidget {
  const MDView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MdCubit(),
      child: const Scaffold(body: MdViewBody()),
    );
  }
}
