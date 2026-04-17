import 'package:ailixir/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:ailixir/features/history/presentation/widgets/history_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatelessWidget {
  static const routeName = '/history';
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit()..loadHistory(),
      child: const Scaffold(body: HistoryViewBody()),
    );
  }
}
