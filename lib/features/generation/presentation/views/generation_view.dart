import 'package:ailixir/features/generation/presentation/cubits/generation_cubit.dart';
import 'package:ailixir/features/generation/presentation/widgets/generation_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerationView extends StatelessWidget {
  const GenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenerationCubit(),
      child: const Scaffold(body: GenerationViewBody()),
    );
  }
}
