import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/profile/data/models/profile_model.dart';
import 'package:ailixir/features/profile/data/repos/profile_repo.dart';
import 'package:ailixir/features/profile/presentation/widgets/credits_island.dart';
import 'package:ailixir/features/profile/presentation/widgets/extra.dart';
import 'package:ailixir/features/profile/presentation/widgets/history_card.dart';
import 'package:ailixir/features/profile/presentation/widgets/info_card.dart';
import 'package:ailixir/features/profile/presentation/widgets/profile_title.dart';
import 'package:ailixir/features/profile/presentation/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});
  @override
  State<StatefulWidget> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  ProfileModel? _profile;
  bool _failed = false;
  final ProfileRepo _repo = ProfileRepo();
  @override
  void initState() {
    super.initState();
    _repo.getTestProfile("").then((v) {
      v.fold(
        (f) {
          _failed = true;
        },
        (profile) {
          setState(() {
            _profile = profile;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(child: Text("Failed to fetch profile"));
    }
    if (_profile == null) {
      return Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          vertical: 0.03.sh,
          horizontal: 0.03.sw,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  ProfileTitle(username: _profile?.name ?? ""),
                  iconLabel(
                    "Usage Statistis",
                    Icons.query_stats,
                    style: AppTextStyles.labellarge,
                    color: AppColors.cyan500,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 10,
                    children: [
                      InfoCard(
                        iconColor: AppColors.blue700,
                        icon: Icons.biotech,
                        infoTitle: "Ligand Generation",
                        data: 45,
                        footnote: "+12% from last month",
                      ),
                      InfoCard(
                        iconColor: AppColors.purple700,
                        icon: Icons.connect_without_contact,
                        infoTitle: "Docking Runs",
                        data: 120,
                        footnote: "+5% from last month",
                      ),
                      InfoCard(
                        iconColor: AppColors.green700,
                        icon: Icons.biotech,
                        infoTitle: "MD Simulations",
                        data: 12,
                        footnote: "Stable Usage",
                      ),
                    ],
                  ),
                  HistoryCard(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreditsIsland(),
                  iconLabel(
                    "Subsciptions",
                    Icons.bookmark,
                    style: AppTextStyles.labellarge,
                    color: AppColors.cyan500,
                  ),
                  subscriptionCard(),
                  StatusCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
