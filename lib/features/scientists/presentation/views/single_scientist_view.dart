import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:ailixir/features/scientists/data/models/scientist_package.dart';
import 'package:ailixir/features/scientists/presentation/widgets/single_scientist_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleScientistView extends StatefulWidget {
  static const String routeName = "/singlescientist";
  final ScientistPackage package;
  const SingleScientistView({super.key, required this.package});
  @override
  State<StatefulWidget> createState() => _SingleScientistViewState();
}

class _SingleScientistViewState extends State<SingleScientistView> {
  List<AwardModel> _awards = [];
  bool err = false;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _getAwards();
  }

  void _getAwards() {
    loading = true;
    widget.package.cubit
        .getAwards(widget.package.scientist.id)
        .then((v) {
          setState(() {
            _awards = v;
            loading = false;
            err = false;
          });
        })
        .onError((e, st) {
          setState(() {
            err = true;
            loading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 0.04.sw,
              height: 0.04.sw,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.package.scientist.imageUrl),
                  fit: BoxFit.cover,
                ),
                border: Border.all(width: 1.5, color: AppColors.white),
                borderRadius: BorderRadiusGeometry.all(Radius.circular(12.r)),
              ),
            ),
            SizedBox(width: 10),
            Text("${widget.package.scientist.name}'s won awards"),
          ],
        ),
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
                      _getAwards();
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
            )
          : (loading
                ? Center(child: CircularProgressIndicator())
                : SingleScientistViewBody(awards: _awards)),
    );
  }
}
