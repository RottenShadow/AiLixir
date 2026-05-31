import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/admet/domain/entities/admet_prediction_entity.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_metric_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdmetCompoundCard extends StatelessWidget {
  final int index;
  final AdmetPredictionEntity prediction;

  const AdmetCompoundCard({
    super.key,
    required this.index,
    required this.prediction,
  });

  void _copyResult(BuildContext context) {
    final text = '''
Compound #$index
SMILES: ${prediction.smiles}

Absorption: ${prediction.absorption.toStringAsFixed(3)}
Distribution: ${prediction.distribution.toStringAsFixed(3)}
Metabolism: ${prediction.metabolism.toStringAsFixed(3)}
Excretion: ${prediction.excretion.toStringAsFixed(3)}
Toxicity: ${prediction.toxicity.toStringAsFixed(3)}
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Result copied to clipboard'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.slate800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toxicityColor = prediction.toxicity > 0.5
        ? AppColors.red400
        : AppColors.admetPositive;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.brandBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.admetPositive.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.admetPositive.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '#$index',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.admetPositive,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    prediction.smiles,
                    style: AppTextStyles.bodysmall.copyWith(
                      color: AppColors.admetSmiles,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: toxicityColor,
                    boxShadow: [
                      BoxShadow(
                        color: toxicityColor.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.brandBorder, height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
            child: Column(
              children: [
                AdmetMetricRow(name: 'Absorption', value: prediction.absorption),
                AdmetMetricRow(name: 'Distribution', value: prediction.distribution),
                AdmetMetricRow(name: 'Metabolism', value: prediction.metabolism),
                AdmetMetricRow(name: 'Excretion', value: prediction.excretion),
                AdmetMetricRow(name: 'Toxicity', value: prediction.toxicity),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _copyResult(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.admetPositive.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColors.admetPositive.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy,
                            size: 12.sp,
                            color: AppColors.admetPositive,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Copy result',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.admetPositive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
