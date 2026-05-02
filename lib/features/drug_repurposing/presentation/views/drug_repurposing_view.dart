import 'package:ailixir/features/drug_repurposing/data/repositories/drug_repurposing_repository.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/full/dr_full_cubit.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/quick/dr_quick_cubit.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/dr_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DrugRepurposingView extends StatelessWidget {
  const DrugRepurposingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              DrQuickCubit(repository: GetIt.I<DrugRepurposingRepository>()),
        ),
        BlocProvider(
          create: (_) =>
              DrFullCubit(repository: GetIt.I<DrugRepurposingRepository>()),
        ),
      ],
      child: const Scaffold(body: DrViewBody()),
    );
  }
}
