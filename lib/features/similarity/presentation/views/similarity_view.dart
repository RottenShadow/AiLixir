import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/similarity/presentation/views/similarity_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimilarityView extends StatelessWidget {
  SimilarityView({super.key});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate1000,
      child: Center(
        child: Container(
          width: 0.6.sw,
          height: 0.6.sh,
          decoration: BoxDecoration(
            color: AppColors.slate800,

            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: 0.05.sh,
              horizontal: 0.1.sw,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.coronavirus,
                  color: AppColors.brandBlue,
                  size: 0.13.sh,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Your Compound",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brandBlue),
                    ),
                  ),
                  controller: controller,
                ),
                MaterialButton(
                  onPressed: () {
                    context.navigateTo(
                      SimilarityResultView.routeName,
                      arguments: controller.text,
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  color: AppColors.brandBlue,
                  child: Text(
                    "Submit Compound",
                    style: AppTextStyles.labelmedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
