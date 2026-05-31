import 'package:flutter/material.dart';
import 'package:ailixir/features/chemical_search/presentation/cubits/chemical_search_cubit.dart';
import 'package:ailixir/features/chemical_search/presentation/widgets/chemical_search_view_body.dart';

class ChemicalSearchView extends StatefulWidget {
  const ChemicalSearchView({super.key});

  @override
  State<ChemicalSearchView> createState() => _ChemicalSearchViewState();
}

class _ChemicalSearchViewState extends State<ChemicalSearchView> {
  final _retrievalCubit = ChemicalSearchCubit(fullRag: false);
  final _fullRagCubit = ChemicalSearchCubit(fullRag: true);

  @override
  void dispose() {
    _retrievalCubit.close();
    _fullRagCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChemicalSearchViewBody(
        retrievalCubit: _retrievalCubit,
        fullRagCubit: _fullRagCubit,
      ),
    );
  }
}
