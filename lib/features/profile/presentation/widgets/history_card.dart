import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  Widget historyItem({
    String name = "test",
    String date = "2 Hours Ago",
    String id = "#0000",
    int cost = 1,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTextStyles.labellarge),
            Text(
              "$date • JobID #$id",
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.authTextSecondary,
              ),
            ),
          ],
        ),
        Text(
          "-$cost Credits",
          style: AppTextStyles.labelsmall.copyWith(
            color: AppColors.authTextSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: AppColors.authTextSecondary.withAlpha(100),
              ),
              borderRadius: BorderRadiusGeometry.circular(12.r),
            ),
            color: AppColors.cardBackground,
            child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Computation History", style: AppTextStyles.labellarge),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 20,
                            children: [historyItem(), historyItem()],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "View All History",
                            style: AppTextStyles.labelsmall.copyWith(
                              color: AppColors.authTextSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
