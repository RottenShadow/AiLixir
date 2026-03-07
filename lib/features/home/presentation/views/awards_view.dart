import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/home/presentation/cubits/award_cubits/award_cubit.dart';
import 'package:ailixir/features/home/presentation/widgets/awards_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AwardsView extends StatelessWidget {
  static const routeName = '/awards';
  String query;
  AwardsView({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Awards"),
        backgroundColor: AppColors.slate1000,
      ),
      body: BlocBuilder<AwardsCubit, AwardState>(
        builder: (listener_context, state) {
          if (state is AwardLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AwardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ERROR: FAILED TO FETCH AWARDS",
                    style: TextStyle(color: AppColors.red800),
                  ),
                  IconButton(
                    onPressed: () {
                      GetIt.I.get<AwardsCubit>().getAwards(query);
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
            );
          }
          return AwardsViewBody(query: query, awards: state.awards);
        },
      ),
    );
  }
}
