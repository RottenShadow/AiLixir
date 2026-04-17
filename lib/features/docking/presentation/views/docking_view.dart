import 'package:ailixir/features/docking/presentation/cubits/docking_cubit.dart';
import 'package:ailixir/features/docking/presentation/widgets/docking_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DockingView extends StatelessWidget {
  const DockingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DockingCubit(),
      child: const Scaffold(body: DockingViewBody()),
    );
  }
}
