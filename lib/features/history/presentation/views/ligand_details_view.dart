import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/features/history/presentation/cubits/ligand_details_cubit/ligand_details_cubit.dart';
import 'package:ailixir/features/history/presentation/widgets/ligand_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LigandDetailsView extends StatelessWidget {
  static const routeName = '/ligand-details';
  final LigandEntity ligand;

  const LigandDetailsView({super.key, required this.ligand});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LigandDetailsCubit()..loadDetails(ligand),
      child: Scaffold(body: LigandDetailsBody(ligand: ligand)),
    );
  }
}
