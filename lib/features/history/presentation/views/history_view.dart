import 'package:ailixir/features/history/presentation/cubits/docking_history_cubit/docking_history_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/drug_repurposing_cubit/drug_repurposing_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/generation_history_cubit/generation_history_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/history_tab_cubit/history_tab_cubit.dart';
import 'package:ailixir/features/history/presentation/cubits/md_history_cubit/md_history_cubit.dart';
import 'package:ailixir/features/history/presentation/widgets/history_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatelessWidget {
  static const routeName = '/history';
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HistoryTabCubit()),
        BlocProvider(create: (_) => GenerationHistoryCubit()..load()),
        BlocProvider(create: (_) => DockingHistoryCubit()..load()),
        BlocProvider(create: (_) => MdHistoryCubit()..load()),
        BlocProvider(create: (_) => DrugRepurposingCubit()..load()),
      ],
      child: const Scaffold(body: HistoryViewBody()),
    );
  }
}
