import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class LogPanel extends StatelessWidget {
  final List<String> logs;

  const LogPanel({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

    final combined = logs.join('\n');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            combined,
            style: AppTextStyles.bodyxs.copyWith(
              color: AppColors.slate400,
              fontFamily: 'monospace',
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
