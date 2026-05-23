import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/presentation/cubits/award_cubit.dart';
import 'package:ailixir/features/awards/presentation/widgets/single_award_view_body.dart';
import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SingleAwardView extends StatefulWidget {
  static const routeName = "/singleaward";
  final AwardModel award;
  final AwardsCubit cubit;
  const SingleAwardView({super.key, required this.award, required this.cubit});
  @override
  State<StatefulWidget> createState() {
    return _SingleAwardViewState();
  }
}

class _SingleAwardViewState extends State<SingleAwardView> {
  List<ScientistModel> scientists = [];
  bool err = false;
  @override
  void initState() {
    super.initState();
    getScientists();
  }

  void getScientists() {
    widget.cubit
        .getTestScientists(widget.award.id)
        .then((v) {
          setState(() {
            scientists = v;
          });
        })
        .onError((_, _) {
          setState(() {
            err = true;
          });
        });
  }

  Widget _title(String name) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            AppColors.awardNameGradientTop,
            AppColors.awardNameGradientBottom,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: Row(
        spacing: 10,
        children: [
          Icon(Icons.emoji_events, size: AppTextStyles.large.fontSize),
          Text("$name Winners"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(widget.award.name),
        backgroundColor: AppColors.slate1000,
      ),
      body: err
          ? Center(
              child: Column(
                children: [
                  Text(
                    "Failed to load prize winners. Retry.",
                    style: AppTextStyles.h1.copyWith(color: AppColors.red500),
                  ),
                  IconButton(
                    onPressed: () {
                      getScientists();
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
            )
          : (scientists.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SingleAwardViewBody(
                    award: widget.award,
                    scientists: scientists,
                  )),
    );
  }
}
