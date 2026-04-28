import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/profile/presentation/widgets/credits_island.dart';
import 'package:ailixir/features/profile/presentation/widgets/extra.dart';
import 'package:ailixir/features/profile/presentation/widgets/info_card.dart';
import 'package:ailixir/features/profile/presentation/widgets/profile_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: 0.03.sh,
        horizontal: 0.03.sw,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ProfileTitle(),
                iconLabel(
                  "Usage Statistis",
                  Icons.query_stats,
                  style: AppTextStyles.labellarge,
                  color: AppColors.cyan500,
                ),
                Row(
                  spacing: 20,
                  mainAxisSize: MainAxisSize.max,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
