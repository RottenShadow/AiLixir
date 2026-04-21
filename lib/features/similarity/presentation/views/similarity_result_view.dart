import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/similarity/cubits/similarity_result_cubit.dart';
import 'package:ailixir/features/similarity/presentation/widgets/similarity_result_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarityResultView extends StatelessWidget {
  const SimilarityResultView({super.key, required this.smileQuery});
  final String smileQuery;
  static const String routeName = "/similarityres";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.slate1000),
      body: BlocProvider(
        create: (context) =>
            SimilarityResultCubit()..getTestSimilar(smileQuery),
        child: SimilarityResultViewBody(),
      ),
    );
  }
}
